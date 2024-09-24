#!/usr/bin/env bash

pip install scipy
cd "$(dirname "$0")"
python attacker.py
