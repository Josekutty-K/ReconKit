# ReconKit
ReconKit is a custom bash script which I created to automate recon processes like subdomain enumeration, live probing, historical URLs, finding parameters, and takeover detection and arranging every result in a clean and organised format. Perfect for bug bounty hunters and pentesters.

## 🎯 Features
- 🔍 **Subdomain Enum**: subfinder + assetfinder + findomain
- ✅ **Live Probing**: httprobe
- 📜 **Historical URLs**: waybackurls + gau  
- ⚙️ **Parameters**: unfurl
- 💥 **Takeovers**: subjack
- 📁 **Organized Output**: Clean folder structure

## 🛠️ Prerequisites
Make sure all these tools are installed and accessible from anywhere:

```bash
subfinder assetfinder findomain httprobe waybackurls gau unfurl subjack

# Download fingerprints.json for subjack to ~/go/bin/
curl -sL https://raw.githubusercontent.com/haccer/subjack/master/fingerprints.json -o ~/go/bin/fingerprints.json

# Verify (should show your file)
ls ~/go/bin/ | grep fingerprints.json
```

## 🚀 Quick Start

```bash
# Clone the repo
git clone https://github.com/Josekutty-K/ReconKit.git
cd ReconKit

# Make executable
chmod +x reconkit

# Run recon!
./reconkit hackerone.com
```
## 📂 Example Output

```bash
recon_hackerone.com/
├── hackerone.com-subfinder.txt
├── hackerone.com-findomain.txt      
├── hackerone.com-assetfinder.txt     
├── hackerone.com-live-subs.txt     
├── hackerone.com-params.txt        
├── hackerone.com-takeovers.txt      
└── hackerone.com-uniq-urls.txt     

