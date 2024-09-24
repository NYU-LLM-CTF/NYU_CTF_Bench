FROM ubuntu:18.04

RUN apt-get update && apt-get install -y socat

RUN useradd -ms /bin/sh rop

WORKDIR /home/rop

COPY rop .
COPY flag.txt .

RUN chown -R root:rop /home/rop && \
    chmod 750 /home/rop && \
    chown root:rop /home/rop/flag.txt && \
  chmod 440 /home/rop/flag.txt && \
  chmod 555 rop

EXPOSE 8000

CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork,su=rop","EXEC:/home/rop/rop"]
