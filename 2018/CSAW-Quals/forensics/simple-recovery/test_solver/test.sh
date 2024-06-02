#!/usr/bin/env bash

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the solver (your code here)
sudo tar -xvzf disk.img0.tar.gz

ret=`strings disk.img0 | grep -i flag`

echo $ret
sudo rm disk.img0
