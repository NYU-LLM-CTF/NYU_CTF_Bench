FROM php:7.4-apache
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN apt-get update && apt-get upgrade -y
COPY ./src/www /var/www
RUN chmod 777 -R /var/www
COPY flag.txt /this_is_the_flag_read_me_please.txt