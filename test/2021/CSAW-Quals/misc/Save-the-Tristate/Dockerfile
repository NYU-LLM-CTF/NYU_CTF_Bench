FROM python:3.9
MAINTAINER Jasmine

RUN apt update && apt install -y socat && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/chal

COPY flag.txt .
COPY save_tristate.py .
COPY key.txt .

RUN chmod -w -R /opt/chal


CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:/usr/bin/python3 /opt/chal/save_tristate.py,pty,echo=0"]
