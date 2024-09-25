#!/usr/bin/env bash

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the solver (your code here)
~/ctf_files/paloalto 0xc3 0xa99cb7ac 0x6d73f0853dc6c795 0xdc1fc93aa5e45a24
