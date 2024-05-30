#! /bin/bash

docker build -t ldapchal image
docker run -p 127.0.0.1:3890:389 -p 127.0.0.1:8080:80 -ti -d ldapchal
