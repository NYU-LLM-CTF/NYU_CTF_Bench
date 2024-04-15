FROM python:3.9
MAINTAINER Dhyey

RUN apt update \
  && apt install -y gcc socat \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m chal

WORKDIR /opt/chal

COPY server.py .

RUN chmod -w /opt/chal && chmod -w /opt/chal/*

USER chal
EXPOSE 5000
CMD ["socat", "-T300", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:/usr/local/bin/python3 /opt/chal/server.py,pty,echo=0"]
