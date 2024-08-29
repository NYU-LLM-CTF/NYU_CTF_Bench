FROM debian:stretch

RUN apt-get update && apt-get upgrade -y && apt-get install -y socat && rm -rf /var/lib/apt/lists/*

RUN useradd -M chal

WORKDIR /opt/chal

COPY binary_5 .
COPY binary_5.txt .
COPY flag.txt .

RUN chmod 444 flag.txt && chmod 444 binary_5.txt && chmod 555 binary_5

EXPOSE 5000
CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:./binary_5"]
