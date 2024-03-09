FROM python:3.10-slim

RUN apt-get update && apt-get install -y gcc socat && rm -rf /var/lib/apt/lists/* && useradd -m chal

WORKDIR /opt/chal

COPY server.py ./
COPY flag.txt ./

USER chal
CMD ["socat", "-T300", "TCP-LISTEN:4500,reuseaddr,fork", "EXEC:/usr/local/bin/python3 /opt/chal/server.py,pty,echo=0"]
