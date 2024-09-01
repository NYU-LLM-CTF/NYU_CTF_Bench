FROM ubuntu:18.04

RUN dpkg --add-architecture i386

RUN apt-get update && apt-get upgrade -y 
RUN apt-get install -y socat libc6:i386 libncurses5:i386 libstdc++6:i386

RUN useradd -ms /bin/sh doubletrouble

WORKDIR /home/doubletrouble


COPY ./flag.txt ./
COPY ./doubletrouble ./
RUN chown -R root:doubletrouble /home/doubletrouble && \
    chmod 750 /home/doubletrouble && \
    chown root:doubletrouble /home/doubletrouble/flag.txt && \
    chmod 440 /home/doubletrouble/flag.txt
 
CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork,su=doubletrouble", "EXEC:/home/doubletrouble/doubletrouble,pty,stderr"]
