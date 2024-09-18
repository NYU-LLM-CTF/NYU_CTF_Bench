#!/usr/bin/env bash

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the solver (your code here)
pip install uncompyle6
sudo apt install -y git

mkdir /tmp/sourcery
cd /tmp/sourcery
unzip ~/ctf_files/sourcery.zip
git show 87f8640fffc5cdbad24ea71dec92eee737448490:__pycache__/secret.cpython-38.pyc >> secret.pyc
uncompyle6 secret.pyc >> secret.py

sed -n '/seed =/,/]$/p' secret.py  | sed 's/    seed/seed/' > solve.py
echo 'char = "".join([s for i,s in sorted(seed, key=lambda x:x[0])])' >> solve.py
echo 'import base64; print(base64.b64decode(char).decode());' >> solve.py
python3 solve.py
