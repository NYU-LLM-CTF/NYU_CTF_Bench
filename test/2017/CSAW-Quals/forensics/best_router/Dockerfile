FROM ubuntu:16.04

# install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apache2 \
    && rm -r /var/lib/apt/lists/*
RUN a2enmod cgid

COPY ./000-default.conf /etc/apache2/sites-enabled/000-default.conf

RUN rm -rf /var/www/*
COPY src/ /var/www
RUN chmod 755 /var/www/*.pl

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]