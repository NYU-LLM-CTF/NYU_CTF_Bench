FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y socat python-dev python

RUN useradd -ms /bin/sh TakeAnL
COPY checker.py /home/TakeAnL
COPY server.py /home/TakeAnL

WORKDIR /home/TakeAnL

ADD . /

USER TakeAnL
CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork", "EXEC:/usr/bin/timeout 5 /home/TakeAnL/server.py"]
