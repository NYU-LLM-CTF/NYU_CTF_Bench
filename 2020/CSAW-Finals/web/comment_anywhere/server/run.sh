#!/bin/bash

while :; do
    python3 seed.py
    PYTHONUNBUFFERED=TRUE
    timeout 30m gunicorn --bind 0.0.0.0:8000 app:app --access-logfile - --error-logfile - --capture-output --enable-stdio-inheritance
    rm comments.db
done
