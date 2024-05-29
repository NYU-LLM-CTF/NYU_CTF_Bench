FROM ubuntu:16.04
# its 16.04 because of libc version

RUN apt-get update && apt-get upgrade -y 
RUN apt-get install -y socat

RUN useradd -ms /bin/sh alieninvasion

WORKDIR /home/alieninvasion

COPY ./art.txt ./
COPY ./flag.txt ./
COPY ./aliensVSsamurais ./
COPY ./run.sh ./
RUN chown -R root:alieninvasion /home/alieninvasion && \
    chmod 750 /home/alieninvasion && \
    chown root:alieninvasion /home/alieninvasion/flag.txt && \
    chmod 440 /home/alieninvasion/flag.txt && \
    chmod 440 /home/alieninvasion/art.txt && \
    chmod 550 /home/alieninvasion/run.sh && \
    chmod 550 /home/alieninvasion/aliensVSsamurais

EXPOSE 8000

CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork,su=alieninvasion", "EXEC:/home/alieninvasion/run.sh,pty,raw,stderr,echo=0"]
