#!/bin/sh

go run main.go -mainAddress http://127.0.0.1:5000 -localAddress http://127.0.0.1:5001 -key abc123 -port 5001 -chunkPath .chunk1
