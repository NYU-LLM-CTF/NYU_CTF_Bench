FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y php libapache2-mod-php apache2 supervisor php-mysql

RUN mkdir -p /var/log/supervisord

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN rm /var/www/html/index.html

EXPOSE 80

RUN useradd supervisor
ADD htdocs/* /var/www/html/
COPY flag /flag


CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf
