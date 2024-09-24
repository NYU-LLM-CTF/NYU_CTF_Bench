FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y \
	apt-utils \ 
	build-essential \
	socat

RUN useradd -ms /bin/sh mina
WORKDIR /home/mina

COPY ./flag.txt ./
COPY ./traveller ./
COPY ./run.sh ./

RUN chown -R root:mina /home/mina && \
    chmod 750 /home/mina && \
    chown root:mina /home/mina/flag.txt && \
    chmod 440 /home/mina/flag.txt && \
    chmod 550 /home/mina/traveller && \
    chmod 550 /home/mina/run.sh

EXPOSE 8000

CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork,su=mina", "EXEC:/home/mina/run.sh,pty,rawer"]