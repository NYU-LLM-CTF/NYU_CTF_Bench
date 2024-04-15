FROM python:3.9
MAINTAINER Dhyey

RUN apt update \
  && apt install -y sagemath socat \
  && pip3 install pycryptodome sympy \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m chal

WORKDIR /opt/chal

COPY flag.txt .
COPY server.sage .
COPY mov_attack_curves.json .
COPY smarts_attack_curves.json .
COPY singular_curves.json .

RUN chown chal:chal /opt/chal && chmod -w /opt/chal/*

USER chal
CMD ["socat", "-T300", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:/usr/bin/sage /opt/chal/server.sage,pty,echo=0"]
