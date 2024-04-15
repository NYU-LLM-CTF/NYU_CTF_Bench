#!/bin/sh

curl "http://localhost:5001/chunkserver/read/$1/$2" -H 'APIKEY: abc123' #| jq
