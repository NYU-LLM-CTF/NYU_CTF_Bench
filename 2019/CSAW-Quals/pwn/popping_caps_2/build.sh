#!/bin/bash

docker stop popping_caps2 && docker rm popping_caps2
docker build -t popping_caps2 .
docker run -dit --name popping_caps2 popping_caps2
docker cp popping_caps2:/home/popping_caps/popping_caps ./
docker cp popping_caps2:/lib/x86_64-linux-gnu/libc-2.27.so ./libc.so.6
docker kill popping_caps2
docker rm popping_caps2