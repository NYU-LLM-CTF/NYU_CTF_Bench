#!/bin/bash

Xvfb :99 -ac -screen 0 1920x1080x24 -nolisten tcp &

export DISPLAY=:99

python3 admin_bot.py
