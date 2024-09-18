#!/usr/bin/env bash

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the solver (your code here)
nc misc.chal.csaw.io 9998 < payload.txt
