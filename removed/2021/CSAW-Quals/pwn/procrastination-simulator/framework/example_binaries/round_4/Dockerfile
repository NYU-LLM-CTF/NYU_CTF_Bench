FROM debian:stretch

RUN apt-get update && apt-get upgrade -y && apt-get install -y socat && rm -rf /var/lib/apt/lists/*

RUN useradd -M chal

WORKDIR /opt/chal

COPY binary_4 .
COPY message.txt .
COPY binary_4.txt .

RUN chmod 444 message.txt && chmod 555 binary_4 && chmod 444 binary_4.txt

EXPOSE 5000
CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:./binary_4"]
