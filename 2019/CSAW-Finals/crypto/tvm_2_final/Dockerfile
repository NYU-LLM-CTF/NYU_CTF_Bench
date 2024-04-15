FROM ubuntu:18.04

RUN apt update -y && apt upgrade -y && apt install -y socat

WORKDIR /opt

COPY server/ ./

EXPOSE 8000
CMD socat -T60 TCP-LISTEN:8000,reuseaddr,fork EXEC:/opt/tvm
