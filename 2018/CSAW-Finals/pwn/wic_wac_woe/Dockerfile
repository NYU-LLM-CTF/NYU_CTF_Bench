FROM  ubuntu:16.04

RUN apt-get update -y && apt-get install -y libpangocairo-1.0-0 libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxi6 libxtst6 libnss3 libcups2 libxss1 libxrandr2 libgconf2-4 libasound2 libatk1.0-0 libgtk-3-0 curl supervisor python2.7 python-pip && (curl -sL https://deb.nodesource.com/setup_8.x | bash -) && apt-get install -y nodejs && npm i puppeteer && pip install flask requests gunicorn && groupadd -g 1000 app && useradd -g app -m -u 1000 app -s /bin/bash
EXPOSE 8080

COPY . /

RUN "/setup.sh"

CMD ["/usr/bin/supervisord"]
#CMD ["bash"]
