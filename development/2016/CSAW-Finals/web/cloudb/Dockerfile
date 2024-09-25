FROM tutum/lamp:latest

RUN rm -rf /app

COPY ./src /var/www/html
COPY ./mysql-setup.sh /

CMD "/run.sh"
