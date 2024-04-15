FROM ubuntu:20.04
RUN apt-get update && apt-get -y upgrade


RUN apt-get install -y lib32z1 xinetd
RUN useradd -u 5000 -m pwn

WORKDIR /home/pwn
COPY public/pwn .
COPY public/CSAW-GAME .
COPY flag .
COPY ./xinetd /etc/xinetd.d/xinetd
RUN chmod 755 /home/pwn/*
RUN chmod -w /home/pwn

EXPOSE 8888
CMD ["/usr/sbin/xinetd", "-dontfork"]