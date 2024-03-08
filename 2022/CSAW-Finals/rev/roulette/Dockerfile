FROM ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y socat openjdk-8-jre-headless default-jdk
RUN groupadd -r ctf && useradd -r -g ctf ctf
RUN chmod 1733 /tmp /var/tmp /dev/shm


WORKDIR /home/ctf

ADD chall.java .
RUN chmod 500 ./chall.java
RUN chown ctf:root . -R
ADD flag.txt .
RUN chmod 444 ./flag.txt

USER ctf
CMD socat TCP-L:4200,fork,reuseaddr EXEC:"java chall.java",pty,stderr,setsid,sane,raw,echo=0
EXPOSE 4200
