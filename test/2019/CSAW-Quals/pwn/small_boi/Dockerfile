FROM ubuntu:18.04
MAINTAINER tnek

RUN apt-get update && apt-get install -y socat

RUN useradd -ms /bin/sh small_boi
WORKDIR /home/small_boi

COPY ./small_boi ./
COPY ./flag.txt ./

RUN chown -R root:small_boi /home/small_boi && \
     chmod 750 /home/small_boi && \
     chmod 550 /home/small_boi/small_boi && \
     chown root:small_boi /home/small_boi/flag.txt && \
     chmod 440 /home/small_boi/flag.txt

EXPOSE 8000

CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork,su=small_boi","EXEC:/home/small_boi/small_boi,pty,ctty,echo=0"]
