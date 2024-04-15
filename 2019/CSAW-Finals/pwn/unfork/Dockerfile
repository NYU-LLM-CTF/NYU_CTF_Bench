FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y socat qemu

COPY ./bzImage /
COPY ./build/disk.img /
COPY ./run.sh /

EXPOSE 9005
CMD ["socat", "-T60", "TCP-LISTEN:9005,reuseaddr,fork", "EXEC:/run.sh"]
