FROM debian:stretch

RUN apt update && apt install -y socat && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/chal

COPY haySTACK .
COPY flag.txt .

RUN chmod 444 flag.txt && chmod 555 haySTACK

USER nobody
CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork","EXEC:./haySTACK"]