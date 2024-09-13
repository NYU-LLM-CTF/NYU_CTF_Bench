#!/bin/sh


echo "starting, first sleeping 2 seconds"
sleep 2
python db_migration.py
gunicorn --log-level debug --workers 8 -b 0.0.0.0:$SERVER_PORT app:app
sleep infinity