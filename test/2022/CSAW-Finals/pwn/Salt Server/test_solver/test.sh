#!/usr/bin/env bash

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the solver (your code here)

sudo apt install -y dnsutils
ADDR=$(nslookup pwn.chal.csaw.io | sed -n '/^Address: \([0-9]\+\.\)\{3\}[0-9]\+/s/Address: //p')
./saltclient $ADDR
