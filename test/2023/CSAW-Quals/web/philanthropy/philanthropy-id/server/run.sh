#!/bin/sh

python /app/run_db.py

echo "starting"
gunicorn -b 0.0.0.0:"$SERVER_PORT" -w 8 app:app &
sleep infinity
