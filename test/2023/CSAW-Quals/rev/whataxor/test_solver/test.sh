#!/usr/bin/env bash

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the solver (your code here)
r2 -e scr.color=false -q -c 's 0x851; pd 71' ~/ctf_files/whataxor | \
    sed  -n '/mov byte/s/[^,]*,//p' | \
    python3 -c 'import sys; print("".join([chr(int(line.strip(), 16)^0xAA) for line in sys.stdin]));'
