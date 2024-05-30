FROM ubuntu:16.04
MAINTAINER Sai Vegasena

#installation
RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    socat

#user

RUN useradd -ms /bin/sh get_it
WORKDIR /home/get_it
COPY ./run.sh ./
COPY ./art.txt ./
COPY ./flag.txt ./
COPY ./get_it  ./


RUN chown -R root:get_it /home/get_it && \
     chmod 750 /home/get_it && \
     chown root:get_it /home/get_it/flag.txt && \
     chmod 440 /home/get_it/flag.txt && \
     chmod 550 /home/get_it/art.txt && \
     chmod 550 /home/get_it/run.sh && \
     chmod 550 /home/get_it/get_it

EXPOSE 1437

ENTRYPOINT ["socat", "-T60", "TCP-LISTEN:1437,reuseaddr,fork,su=get_it","EXEC:/home/get_it/run.sh,pty"]
