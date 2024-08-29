#!/bin/bash

CHAL_NAME="ezpz_challenge"
CHAL_PORT=3788 # pls don't change, it's 0xECC and that's hilarious imho

echo "Building..."
docker build -t $CHAL_NAME .

echo "Starting..."
docker run -p $CHAL_PORT:3788 -d ezpz_challenge
