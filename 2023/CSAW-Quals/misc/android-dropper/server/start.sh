#!/bin/bash

cd /home/ctf
gunicorn -b 0.0.0.0:3003 -w 8 server:app &
sleep infinity