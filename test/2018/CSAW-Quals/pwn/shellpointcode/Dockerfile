FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y 
RUN apt-get install -y socat

RUN useradd -ms /bin/sh shellpointcode

WORKDIR /home/shellpointcode

COPY ./flag.txt ./
COPY ./shellpointcode ./
RUN chown -R root:shellpointcode /home/shellpointcode && \
    chmod 750 /home/shellpointcode && \
    chown root:shellpointcode /home/shellpointcode/flag.txt && \
    chmod 440 /home/shellpointcode/flag.txt

EXPOSE 8000

CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork,su=shellpointcode", "EXEC:/home/shellpointcode/shellpointcode,STDERR"]
