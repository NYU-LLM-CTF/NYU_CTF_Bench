FROM ubuntu:18.04
MAINTAINER N4T_20

RUN apt-get update && apt-get upgrade -y && apt-get install -y socat

RUN useradd -ms /bin/sh bard

WORKDIR /home/bard

COPY bard .
COPY flag.txt .

RUN chown -R root:bard /home/bard && \
    chmod 750 /home/bard && \
    chown root:bard /home/bard/flag.txt && \
    chmod 555 /home/bard/bard && \
    chmod 440 /home/bard/flag.txt

EXPOSE 8000

USER bard
CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,forever,fork", "EXEC:/home/bard/bard,stderr"]
