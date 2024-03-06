#!/bin/bash

cd /app
gunicorn -b 0.0.0.0:5800 -w 8 init:app &
