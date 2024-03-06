#!/bin/sh

python /app/run_db.py

echo "starting"
gunicorn -b 0.0.0.0:4657 -w 8 app:app &
sleep infinity