#!/usr/bin/env bash

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the solver (your code here)
# The answer is hardcoded and can be cracked from the provided files. The server just gives the flag.
echo ba65cf5860ff5a095bbb0ad2c64c08f9adabdff77f4e5ef17d96433f9ddd9ff5 | nc crypto.chal.csaw.io 5050
