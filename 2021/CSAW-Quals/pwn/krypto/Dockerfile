FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y socat qemu iproute2

COPY ./build/disk.real.img /
COPY ./run.sh /

EXPOSE 23750
EXPOSE 30000-30100
CMD ["socat", "-T600", "TCP-LISTEN:23750,reuseaddr,fork", "EXEC:/run.sh"]
