FROM php:7.0-apache

WORKDIR /var/www/html

COPY apache2.conf /etc/apache2/apache2.conf
COPY src/ ./

RUN chmod -R -w ./*

USER nobody
