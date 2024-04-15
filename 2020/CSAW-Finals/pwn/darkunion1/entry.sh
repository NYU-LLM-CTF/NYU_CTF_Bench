#!/bin/bash

cd /app
while true; do
  socat -dd TCP4-LISTEN:5000,fork,reuseaddr \
    EXEC:"./pow 3 ./run.sh -n",pty,echo=1,iexten=0,su=ctf
done
