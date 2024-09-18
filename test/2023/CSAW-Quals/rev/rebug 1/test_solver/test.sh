#!/usr/bin/env bash

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the solver (your code here)
chmod +x ~/ctf_files/test.out
echo -n "123456789abc" | ~/ctf_files/test.out
