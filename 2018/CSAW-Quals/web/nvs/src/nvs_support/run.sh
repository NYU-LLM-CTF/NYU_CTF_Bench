#!/bin/sh
docker run -d --name support-site -v "$PWD/src":/var/www/html --net fakelan --ip 172.16.2.5 php:7.2-apache
