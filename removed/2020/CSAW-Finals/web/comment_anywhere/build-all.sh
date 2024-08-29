#!/bin/bash

BASEDIR=$(dirname "$0")

# Extension
google-chrome --pack-extension=${BASEDIR}/extension --pack-extension-key=${BASEDIR}/extension.pem --no-message-box

exec ${BASEDIR}/build-docker.sh
