FROM python:3.9
MAINTAINER Dhyey

RUN apt update && apt install -y socat gcc \
  && pip3 install pycryptodome sympy inputimeout \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/chal

COPY flag.txt .
COPY server.py .

RUN chmod -w /opt/chal && chmod -w /opt/chal/*
USER nobody

CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:/usr/local/bin/python3 /opt/chal/server.py,pty,echo=0"]
