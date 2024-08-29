FROM  ubuntu:16.04

RUN apt-get update -y && \
    apt-get install -y \
        libpangocairo-1.0-0 libx11-xcb1 libxcomposite1 libxcursor1 \
        libxdamage1 libxi6 libxtst6 libnss3 libcups2 libxss1 libxrandr2 \
        libgconf2-4 libasound2 libatk1.0-0 libgtk-3-0 curl supervisor \
        python2.7 python-pip
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN npm i --before 2018-11-01 puppeteer
RUN pip install Werkzeug==0.14.1 flask==0.12.4 requests==2.20.0 gunicorn==19.9.0 Jinja2==2.10 click==7.0 itsdangerous==1.1.0 MarkupSafe==1.0 certifi==2018.10.15

RUN groupadd -g 1000 app
RUN useradd -g app -m -u 1000 app -s /bin/bash

EXPOSE 8080

COPY . /

RUN "/setup.sh"

CMD ["/usr/bin/supervisord"]
#CMD ["bash"]
