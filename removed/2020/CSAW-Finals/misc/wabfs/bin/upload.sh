#!/bin/sh

curl 'http://localhost:5000/main/upload/Private/flag.txt' -H "APIKEY: ${1}" -XPOST -F 'file=@./flag.txt' | jq
curl 'http://localhost:5000/main/upload/Public/index.txt' -H "APIKEY: ${1}" -XPOST -F 'file=@./index.txt' | jq
