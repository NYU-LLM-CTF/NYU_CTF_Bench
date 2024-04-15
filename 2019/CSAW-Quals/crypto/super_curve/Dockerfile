FROM ubuntu:16.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y socat python3

WORKDIR /opt
COPY flag.txt ./flag.txt
COPY server.py ./server.py
COPY supercurve.py ./supercurve.py

EXPOSE 8000
CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork", "EXEC:python3 /opt/server.py,pty,echo=0"]
