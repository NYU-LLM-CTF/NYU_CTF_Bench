FROM php:7.0-apache
MAINTAINER Oskar
LABEL Description="CSAW 2014-F: Webroot" VERSION='1.0'
# Update
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install libmcrypt-dev
# Files
ADD webroot /var/www/html/
# Execute
EXPOSE 80