FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y --no-install-recommends xinetd qemu-system-x86
RUN apt-get install -y --no-install-recommends socat

RUN useradd ctf
RUN mkdir /app
COPY run.sh entry.sh bzImage ramdisk.img pow /app/

COPY flag.server.img /app/flag.img
ENTRYPOINT ["/app/entry.sh"]
