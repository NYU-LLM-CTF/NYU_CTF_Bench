FROM ubuntu:20.04

RUN apt-get update && apt-get install -y socat libstdc++6

RUN useradd -ms /bin/sh feather

WORKDIR /home/feather

COPY feather .
COPY flag.txt .

RUN chown -R root:feather /home/feather && \
    chmod 750 /home/feather && \
    chmod 440 /home/feather/flag.txt && \
    chmod 555 /home/feather/feather

USER feather
CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork","EXEC:/home/feather/feather"]
