#!/bin/bash

set -ex

./build-docker.sh

if docker ps | grep -q 'comment-anywhere-server'; then
    docker kill comment-anywhere-server
    docker rm comment-anywhere-server
fi

if docker ps | grep -q 'comment-anywhere-admin'; then
    docker kill comment-anywhere-admin
    docker rm comment-anywhere-admin
fi

docker run -d \
       --restart always \
       --name comment-anywhere-server \
       -p 8000:8000 comment-anywhere-server
docker run -d \
       --restart always \
       --name comment-anywhere-admin \
       comment-anywhere-admin
