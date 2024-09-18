#!/bin/bash

docker stop popping_caps && docker rm popping_caps
docker build -t popping_caps .
docker run -dit --name popping_caps popping_caps
docker cp popping_caps:/home/popping_caps/popping_caps ./
docker cp popping_caps:/lib/x86_64-linux-gnu/libc-2.27.so ./libc.so.6
docker kill popping_caps
docker rm popping_caps