#!/bin/bash
docker run -it --rm --privileged -p 216.165.2.34:80:80 --name CTFCHALLENGE -t ctfchallenge $1
