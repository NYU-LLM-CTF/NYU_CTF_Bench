FROM python:3.8
MAINTAINER Dhyey

RUN apt update \
  && apt install -y gcc socat \
  && pip3 install pycryptodome sympy inputimeout \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m chal

WORKDIR /opt/chal

COPY flag.txt .
COPY server.py .
COPY Pokemon_names.txt .

RUN chmod -w /opt/chal && chmod -w /opt/chal/*

USER chal
CMD ["socat", "-T300", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:/usr/local/bin/python3 /opt/chal/server.py,pty,echo=0"]
