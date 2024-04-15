#!/bin/bash

cd "$(dirname "$0")"

# Install docker
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
if ! apt-key fingerprint 0EBFCD88 | grep -q '9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88'; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  if ! apt-key fingerprint 0EBFCD88 | grep -q '9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88'; then
    echo 'Key incorrect'
    exit 1
  fi
fi
sudo add-apt-repository   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce

sudo usermod -a -G docker $(whoami)

(cat | sudo tee /etc/systemd/system/v8.service) <<EOF
[Unit]
Description=CSAW V8 Challenge
After=network.target

[Service]
Type=simple
User=$(whoami)
WorkingDirectory=$(pwd)
ExecStart=$(pwd)/run.sh
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

wget 'https://ret2.io/ab19a73a0a023bdd63ea9e7ad777b528.tar.gz' -O './docker/chrome_70.0.3538.77_csaw.tar.gz'

sudo systemctl daemon-reload
sudo systemctl enable v8

sudo reboot
