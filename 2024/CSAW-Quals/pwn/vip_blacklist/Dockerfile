FROM ubuntu:22.04

RUN apt-get update && apt-get install -y socat

RUN useradd -ms /bin/sh vip
WORKDIR /home/vip

COPY ./vip_blacklist ./
COPY ./flag.txt /

RUN chown -R vip:vip /home/vip && \
     chmod 750 /home/vip && \
     chmod 550 /home/vip/vip_blacklist && \
     chown vip:vip /flag.txt && \
     chmod 440 /flag.txt

EXPOSE 9997

USER vip

CMD ["socat", "-T60", "TCP-LISTEN:9997,reuseaddr,fork","EXEC:/home/vip/vip_blacklist,pty,stderr"]
