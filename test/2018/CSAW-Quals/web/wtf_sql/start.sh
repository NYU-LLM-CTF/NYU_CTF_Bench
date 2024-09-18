#!/bin/bash

mysql -u root -ppassword -e "grant process on *.* to app_sql";
mysql -u root -ppassword -e "grant select on flag.txt to app_sql";
uwsgi --http :9090 --wsgi-file server.py &
