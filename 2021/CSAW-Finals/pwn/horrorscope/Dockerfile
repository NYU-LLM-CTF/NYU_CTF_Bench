FROM ubuntu:21.10
RUN apt-get update && apt-get -y upgrade


RUN apt-get install -y lib32z1 xinetd
RUN useradd -u 5000 -m pwn

WORKDIR /home/pwn
COPY ./public/horrorscope ./
COPY ./oracle.txt ./
COPY ./cookies.txt ./
COPY ./flag.txt ./

COPY ./xinetd /etc/xinetd.d/xinetd
RUN chmod 755 /home/pwn/*
RUN chmod -w /home/pwn


EXPOSE 6666
CMD ["/usr/sbin/xinetd", "-dontfork"]