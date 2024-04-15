FROM mattrayner/lamp:latest-1604

RUN apt-get update && apt-get install -y chromium-browser
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN npm i puppeteer

RUN apt-get remove -y php5.6* libapache2-mod-php5.6 && apt-get install -y libapache2-mod-php7.0 php7.0 php7.0-json php7.0-mysql

COPY ./src /app
RUN chown -R root:root /app
RUN chmod -R a-w /app

COPY ./init_db.sh /
COPY ./db.sql /
RUN chmod +x /init_db.sh

RUN sed -i '$i/init_db.sh' /create_mysql_users.sh

COPY ./supervisord-chromium.conf /etc/supervisor/conf.d/supervisord-chromium.conf

COPY ./admin /admin
RUN groupadd -g 1337 admin && useradd -g admin -m -u 1337 admin -s /bin/bash
RUN chown -R admin:admin /admin
RUN chmod -R go-rwx /admin

RUN mkdir -p /tmp/user_data/1
RUN chown www-data:www-data /tmp/user_data
COPY ./flag.enc /tmp/user_data/1/flag.txt
RUN chmod a-w /tmp/user_data/1/flag.txt

COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

RUN chown -R root:root /app
RUN chmod -R a-w /app

expose 80
