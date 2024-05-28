#!/usr/bin/env bash

#################
## BROUGHT NEEDED FILES INTO SOLVER FOLDER:
## bdos.tar.gz
#################

# Ensure the script fails if any of the commands fail
set -euo pipefail

# Change the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the solver (your code here)

# get the needed files
tar -xzvf bdos.tar.gz 

# run solver
ret=`python solver.py`

# cleanup
rm -r bdos/*
rmdir  bdos
echo $ret
