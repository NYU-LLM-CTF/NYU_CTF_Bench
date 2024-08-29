#!/bin/bash

# https://github.com/mattrayner/docker-lamp/blob/master/supporting_files/run.sh#L34
chown -R root:root /app
chmod -R a-w /app

mysql -uroot -e "CREATE USER 'sfs'@'%' IDENTIFIED BY 'sfs'"
mysql -uroot -e "CREATE DATABASE sfs"
mysql -uroot -e "GRANT ALL PRIVILEGES ON sfs.* TO 'sfs'@'%'"

mysql -u root sfs < db.sql
