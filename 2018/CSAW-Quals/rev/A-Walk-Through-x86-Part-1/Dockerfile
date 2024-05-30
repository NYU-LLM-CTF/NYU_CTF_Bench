FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y socat python3

RUN useradd -ms /bin/sh x86
COPY stage-1-server.py /home/x86

WORKDIR /home/x86

ADD . /

USER x86
CMD ["socat", "-T300", "TCP-LISTEN:8000,reuseaddr,fork", "EXEC:/usr/bin/timeout 300 /home/x86/stage-1-server.py"]
