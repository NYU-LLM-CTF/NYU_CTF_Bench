FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y socat sagemath && rm -rf /var/lib/apt.lists/*

RUN sage -pip install pycrypto

WORKDIR /opt/chal

COPY src/blocks.sage .
COPY src/blocks_sage.py .
COPY src/chall.sage .
COPY src/sig.sage .
COPY src/sig_sage.py .

RUN chmod 555 ./*
EXPOSE 5002

CMD ["socat", "-T600", "TCP-LISTEN:5002,reuseaddr,fork", "EXEC:/usr/bin/sage ./chall.sage"]
