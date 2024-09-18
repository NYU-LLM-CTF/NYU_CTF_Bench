#!/usr/bin/env bash

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the solver (your code here)
CHALTEST=$PWD
CTF=/home/ctfplayer/ctf_files

cd /tmp
curl -LO https://github.com/kimci86/bkcrack/releases/download/v1.6.1/bkcrack-1.6.1-Linux.tar.gz
tar xf bkcrack-1.6.1-Linux.tar.gz

cp -v $CHALTEST/Tax_Ret_Form* .
cp -v $CTF/Tax_Ret_Form* .

bkcrack-1.6.1-Linux/bkcrack -P Tax_Ret_Form_Blank.zip -p Tax_Ret_Form_Blank.pdf -C Tax_Ret_Form_Nov_2021.zip -c Tax_Ret_Form_Nov_2021.pdf | tail -n1 | tee  keys.txt
cat keys.txt

bkcrack-1.6.1-Linux/bkcrack -C Tax_Ret_Form_Nov_2021.zip -k $(<keys.txt) -U cracked.zip cracked

unzip -P cracked cracked.zip

strings Tax_Ret_Form_Nov_2021.pdf | grep -o "flag{[_0-9a-zA-Z]\+}"
