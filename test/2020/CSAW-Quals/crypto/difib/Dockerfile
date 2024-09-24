FROM ubuntu:18.04

RUN apt-get update && apt-get -y install python3-pip socat

WORKDIR /opt
COPY flag.txt .
COPY server.py .

RUN pip3 install secretpy

EXPOSE 8000
CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork", "EXEC:python3 /opt/server.py,STDERR,pty,echo=0"]
