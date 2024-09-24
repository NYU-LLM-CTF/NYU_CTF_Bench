FROM ubuntu:21.04

RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt -y dist-upgrade && apt -y install xinetd python3 python3-gmpy2

RUN useradd ctf

RUN mkdir /app && chown ctf /app
WORKDIR /app

COPY flag.txt /app/flag.txt
COPY chal.py /app/chal.py
COPY interoperable.xinetd /etc/xinetd.d/interoperable

RUN chown -R ctf /app

CMD xinetd -dontfork
EXPOSE 5000
