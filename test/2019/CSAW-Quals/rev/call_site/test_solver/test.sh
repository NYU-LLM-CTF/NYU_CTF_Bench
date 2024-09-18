#!/usr/bin/env bash

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the solver (your code here)
echo 0x400ca0 n1c3k3ym | nc -q5 -w5 rev.chal.csaw.io 8000
