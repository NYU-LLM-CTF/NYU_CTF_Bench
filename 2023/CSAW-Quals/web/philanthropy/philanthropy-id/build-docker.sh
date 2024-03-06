#!/bin/bash
docker rm -f phil_id
docker build --tag=phil_id --build-arg SERVER_PORT=13337 .
docker run -p 13337:13337 --rm --name=phil_id phil_id
