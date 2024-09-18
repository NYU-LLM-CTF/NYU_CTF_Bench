#!/usr/bin/env bash

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the solver (your code here)
curl -F "mFile=@CNN_model.h1.zip" -F "file-submit=upload" http://misc.chal.csaw.io:3000/single
