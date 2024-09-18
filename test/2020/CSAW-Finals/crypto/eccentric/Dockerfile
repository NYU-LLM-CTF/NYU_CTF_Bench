FROM ubuntu:18.04

RUN apt-get update && apt-get -y install python3-pip socat

WORKDIR /opt
COPY server.py .

CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:python3 /opt/server.py,STDERR,pty,echo=0"]
