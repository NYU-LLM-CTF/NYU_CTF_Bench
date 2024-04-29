FROM debian:stretch

RUN sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN sed -i '/stretch-updates/d' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && dpkg --add-architecture i386 && apt-get update && apt-get install -y libc6-i386 socat file build-essential libc6-dev:i386 gcc-multilib && rm -rf /var/lib/apt/lists/*

ARG UID=1000
RUN groupadd -g $UID -o chal
RUN useradd -M -u $UID -g $UID -o -s /bin/bash chal
WORKDIR /opt/chal
USER chal
