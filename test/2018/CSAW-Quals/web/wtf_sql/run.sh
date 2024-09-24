#!/bin/sh

docker run --rm -it -e MYSQL_USER=app_sql -e MYSQL_PASSWORD=app_sql -e MYSQL_DATABASE=app_sql -e MYSQL_ROOT_PASSWORD=password -p9090:9090 --name=wtf_sql wtf_sql
