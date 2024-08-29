FROM ubuntu:18.04
RUN apt-get update && apt-get install -y \
    xinetd \
    qemu-user-static \
    libc6-i386 \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /home/quirky && useradd -U quirky
COPY xinetd /etc/xinetd.d/quirky-emulation
COPY flag /home/quirky/
RUN chmod 444 /home/quirky/flag
COPY quirky-emulation /usr/local/bin/
EXPOSE 4242
CMD ["/usr/sbin/xinetd", "-dontfork"]
