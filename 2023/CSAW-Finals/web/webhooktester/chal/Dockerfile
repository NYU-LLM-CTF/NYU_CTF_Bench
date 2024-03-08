FROM php:8.2-fpm

RUN apt update && \
  apt install -y debian-keyring debian-archive-keyring apt-transport-https  && \
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg && \
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list && \
  apt update && \
  apt install -y caddy && \
  rm -rf /var/lib/apt/lists/*

COPY getflag /getflag
COPY flag.txt /flag.txt
RUN chmod +s /getflag
RUN chmod 400 /flag.txt


COPY Caddyfile /etc/caddy/Caddyfile
COPY index.php /var/www/html/index.php

# Expose port 80 for Caddy
EXPOSE 80

CMD php-fpm -F -R & caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
