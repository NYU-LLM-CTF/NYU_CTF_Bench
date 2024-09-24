FROM ubuntu:22.04

RUN apt update && apt install -y socat && rm -rf /var/lib/apt/lists/*

# RUN useradd -M game

WORKDIR /opt/chal

COPY game .
COPY flag.txt .
COPY map.csv .

RUN chmod 444 flag.txt && chmod 555 game && chmod 444 map.csv

#EXPOSE 5000

USER nobody
CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork","EXEC:./game"]
