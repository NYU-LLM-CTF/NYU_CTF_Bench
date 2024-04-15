#!/bin/bash

while :; do
    python3 seed.py
    timeout 2m gunicorn --bind 0.0.0.0:8000 app:app
    rm comments.db
done
