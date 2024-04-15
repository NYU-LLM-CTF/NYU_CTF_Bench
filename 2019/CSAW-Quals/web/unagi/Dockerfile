FROM ubuntu:16.04


RUN apt-get update -y && apt-get install -y libapache2-mod-php7.0 php7.0 php7.0-json php-xml libapache2-mod-php7.0

RUN a2enmod php7.0
RUN a2enmod rewrite

RUN rm /var/www/html/index.html
COPY ./src /var/www/html/
COPY flag.txt /
COPY jquery.js /var/www/html/
COPY sample.xml /var/www/html/


WORKDIR /var/www/html/
CMD /usr/sbin/apache2ctl -D FOREGROUND
EXPOSE 80