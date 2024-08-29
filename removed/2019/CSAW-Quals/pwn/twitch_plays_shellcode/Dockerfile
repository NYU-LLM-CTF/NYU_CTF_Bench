FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y socat

RUN useradd -ms /bin/sh twitch
WORKDIR /home/twitch

COPY ./shellcode ./
COPY ./flag.txt ./

RUN chown -R root:twitch /home/twitch && \
    chmod 750 /home/twitch &&\
    chmod 550 /home/twitch/shellcode &&\
    chown root:twitch /home/twitch/flag.txt && \
    chmod 440 /home/twitch/flag.txt

EXPOSE 1000

CMD ["socat", "-T60", "TCP-LISTEN:1000,reuseaddr,fork,su=twitch", "EXEC:/home/twitch/shellcode,stderr"]
