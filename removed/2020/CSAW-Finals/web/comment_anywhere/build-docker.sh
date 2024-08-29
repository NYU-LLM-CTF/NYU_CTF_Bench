#!/bin/bash

BASEDIR=$(dirname "$0")

# Server
pushd ${BASEDIR}/server
docker build -t comment-anywhere-server .
popd

# Admin
pushd ${BASEDIR}/admin
rm -rf extension
cp -r ../extension .
docker build -t comment-anywhere-admin -f Dockerfile.admin .
rm -rf extension
popd
