#!/usr/bin/env bash

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

#sudo apt-get install -y python2.7 python2.7-dev python2-setuptools-whl python2-pip-whl
#export PATH=/home/ctfplayer/.local/bin:"${PATH}"
##jpython2.7 get-pip.py
#pip2 install pwntools libnum
# Run the solver (your code here)
#python2.7 -u solver.py

python2 solver.py


