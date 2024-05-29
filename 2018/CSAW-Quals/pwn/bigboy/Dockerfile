FROM ubuntu:16.04
MAINTAINER Sai Vegasena

#installation
RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    socat

#user

RUN useradd -ms /bin/sh bigboy
WORKDIR /home/bigboy

COPY ./art.txt ./
COPY ./boi ./
COPY ./run.sh ./
COPY ./flag.txt ./

RUN chown -R root:bigboy /home/bigboy && \
     chmod 750 /home/bigboy && \
     chown root:bigboy /home/bigboy/flag.txt && \
     chmod 440 /home/bigboy/flag.txt && \
     chmod 550 /home/bigboy/run.sh && \
     chmod 550 /home/bigboy/art.txt


EXPOSE 1436

CMD ["socat", "-T60", "TCP-LISTEN:1436,reuseaddr,fork,su=bigboy","EXEC:/home/bigboy/run.sh,pty"]
