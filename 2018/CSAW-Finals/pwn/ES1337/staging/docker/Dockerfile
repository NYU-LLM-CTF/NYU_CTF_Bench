FROM ubuntu:18.04

RUN apt-get -y update && \
	apt-get -y upgrade && \
    apt-get -y install apt-utils libasound2 libx11-6 libxcursor1 libxext6 libxi6 libxtst6 libx11-xcb1 libxcomposite1 libxdamage1 libcups2 libxss1 libxrandr2 libcairo2 libpangocairo-1.0-0 libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 ca-certificates fonts-liberation libappindicator1 libnspr4 libnss3 lsb-release wget xdg-utils gconf-service libgconf-2-4 locales gdb binutils

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

RUN groupadd -g 1000 chrome && useradd -g chrome -m -u 1000 chrome -s /bin/bash

ADD * /

RUN chmod 111 /read_flag

USER chrome

CMD ["bash"]


