FROM python:3.8
MAINTAINER Dhyey

RUN apt update \
  && apt install -y socat gcc \
  && pip3 install pycryptodome sympy \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m chal

WORKDIR /opt/chal

COPY flag.txt .
COPY server.py .
COPY wiener_attack.json .
COPY sexy_primes.json .
COPY partial_key.json .

RUN chmod -R -w .

USER chal
CMD ["socat", "-T300", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:/usr/local/bin/python3 /opt/chal/server.py,pty,echo=0"]
