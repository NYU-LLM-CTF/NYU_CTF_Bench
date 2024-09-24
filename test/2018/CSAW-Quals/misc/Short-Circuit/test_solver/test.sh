#!/usr/bin/env bash

#https://ctftime.org/writeup/11335

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the solver (your code here)
FLAG_FROM_MANUAL_IMAGE_INSPECTION="flag{owmyhand}"
echo $FLAG_FROM_MANUAL_IMAGE_INSPECTION
