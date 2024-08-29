#!/bin/bash

APIKEY="$(head -c12 /dev/urandom | base64)"
cd $(dirname $(realpath $0))

set -e


docker-compose kill
docker-compose rm -f 
env APIKEY=${APIKEY} docker-compose up -d --force-recreate --build main
env APIKEY=${APIKEY} docker-compose up -d --force-recreate --build chunkserver1 chunkserver2 chunkserver3 chunkserver4 chunkserver5

sleep 3

./bin/upload.sh ${APIKEY}
