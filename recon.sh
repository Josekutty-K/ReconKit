#!/usr/bin/env bash

cat << 'EOF'


█████▄  ██████ ▄█████ ▄████▄ ███  ██     ██ ▄█▀ ██ ██████
██▄▄██▄ ██▄▄   ██     ██  ██ ██ ▀▄██ ▄▄▄ ████   ██   ██
██   ██ ██▄▄▄▄ ▀█████ ▀████▀ ██   ██     ██ ▀█▄ ██   ██

AUTHOR: JOSEKUTTY
GITHUB: https://github.com/Josekutty-K
EOF

echo ""
read -p 'Enter the target domain you want to run the script on: ' target
echo ""
echo "SUBDOMAIN ENUMERATION STARTED ON: $target"
echo ""

mkdir -p "recon_$target"
cd "recon_$target"

subfinder -d "${target}" -o "${target}-subfinder.txt" -silent > /dev/null 2>&1

if [[ -s "${target}-subfinder.txt" ]]; then
        echo ""
        echo "----------SUBFINDER OUTPUT FOR ${target}----------"
        echo "Subdomains Found: $(wc -l < "${target}-subfinder.txt")"
        echo "Output File Name: ${target}-subfinder.txt"
        echo ""
else
        echo "No subdomains were found from subfinder"
fi

assetfinder --subs-only "${target}" > "${target}-assetfinder.txt"

if [[ -s "${target}-assetfinder.txt" ]]; then
        echo ""
        echo "----------ASSETFINDER OUTPUT FOR ${target}----------"
        echo "Subdomains Found: $(wc -l < "${target}-assetfinder.txt")"
        echo "Output File Name: ${target}-assetfinder.txt"
        echo ""
else
        echo "No subdomains were found from assetfinder"
fi

findomain -t "${target}" -u "${target}-findomain.txt" > /dev/null 2>&1
if  [[ -s "${target}-findomain.txt" ]]; then
        echo ""
        echo "----------FINDOMAIN OUTPUT FOR ${target}----------"
        echo "Subdomains Found: $(wc -l < "${target}-findomain.txt")"
        echo "Output File Name: ${target}-findomain.txt"
        echo ""
else
        echo "No subdomains were found from findomain"
fi

echo ""
echo "SORTING UNIQUE SUBDOMAINS TO A NEW FILE..."
echo ""

cat "${target}-subfinder.txt" "${target}-assetfinder.txt" "${target}-findomain.txt" | sort -u > "${target}-uniq-subs.txt"

echo ""
echo "----------UNIQUE SUBDOMAINS OUTPUT----------"
echo "Total Unique Subdomains: $(wc -l < "${target}-uniq-subs.txt")"
echo "Output File Name: ${target}-uniq-subs.txt"
echo ""

echo ""
echo "STARTED PROBING TO FIND LIVE SUBDOMAINS..."
echo ""

cat "${target}-uniq-subs.txt" | httprobe > "${target}-live-subs.txt"

if [[ -s "${target}-live-subs.txt" ]]; then
        echo ""
        echo "----------LIVE SUBDOMAINS FOUND FOR ${target}----------"
        echo "Total Live Subdomains: $(wc -l < "${target}-live-subs.txt")"
        echo "Output File Name: ${target}-live-subs.txt"
        echo ""
else
        echo "No Live Subdomains found for ${target}"
fi

echo ""
echo "FINDING HISTORICAL URLS AND ENDPOINTS OF UNIQUE LIVE SUBDOMAINS"
echo "Note: This may take some time to finish...."
echo ""

# RUNS SIMULTANEOUSLY
cat "${target}-live-subs.txt" | waybackurls > "${target}-waybackurls.txt"  &    # Background job 1
cat "${target}-live-subs.txt" | gau --subs > "${target}-gau.txt" 2>/dev/null     &    # Background job 2
wait                                             # Wait for BOTH to finish

cat "${target}-waybackurls.txt" "${target}-gau.txt" | sort -u > "${target}-uniq-urls.txt"

echo ""
echo "----------HISTORICAL URLS AND ENDPOINTS FOUND FOR ${target}----------"
echo "Urls Found Using Waybackurls: $(wc -l < "${target}-waybackurls.txt")"
echo "Urls Found Using Gau: $(wc -l < "${target}-gau.txt")"
echo "Unique Urls After Sorting: $(wc -l < "${target}-uniq-urls.txt")"
echo "Output File Saved For Unique Urls: ${target}-uniq-urls.txt"

cat "${target}-uniq-urls.txt" | unfurl --unique keys > "${target}-params.txt"

if [[ -s "${target}-params.txt" ]]; then
        echo ""
        echo "----------PARAMETERS ON URL'S FOUND FOR ${target}----------"
        echo "Total Parameters: $(wc -l < "${target}-params.txt")"
        echo "Output File: ${target}-params.txt"
else
        echo "No Parameters have been found..."
fi

echo ""
echo "SCANNING FOR SUBDOMAIN TAKEOVERS..."
echo ""

subjack -w "${target}-uniq-subs.txt" -t 25 -ssl -c /home/kali/go/bin/fingerprints.json -o "${target}-takeovers.txt"

if [[ -s "${target}-takeovers.txt" ]]; then
    echo " TAKEOVERS: $(wc -l < "${target}-takeovers.txt")"
    cat "${target}-takeovers.txt"
else
    echo "No takeovers"
fi
