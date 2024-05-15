#!/usr/bin/env bash

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the solver (your code here)

sudo apt install -y steghide aircrack-ng
cd /tmp

curl -LO https://raw.githubusercontent.com/BigZaphod/COW/master/source/cow.cpp
g++ -DNO_GREETINGS -o cow-interpret  cow.cpp

# Get the steg password
JPG=/home/ctfplayer/ctf_files/farmlang.jpg
PASSWORD=$(strings $JPG | sed -n '/rdf:li xml:lang=/s/<[^>]*>//gp' | sed 's/\s//g' | base64 -d | sed 's/.*: //')

# Extract the zip from the jpeg
steghide extract -p $PASSWORD -sf $JPG
unzip secret_farm.zip

# Get the wordlist using cow interpreter
WORDURL=$(./cow-interpret cow | sed 's/github.com/raw.githubusercontent.com/' | sed 's/blob\///')
curl -LO $WORDURL

# Crack the wifi password, it is the flag
aircrack-ng -w seasons.txt -b "8e:23:74:86:90:91" handshake.cap -l flag.txt
echo "flag{"$(<flag.txt)"}"
