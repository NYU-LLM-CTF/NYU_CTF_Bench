FROM ubuntu:22.04

RUN apt-get update && apt-get install -y socat

RUN useradd -ms /bin/sh golf
WORKDIR /home/golf

COPY ./golf ./
COPY ./flag.txt /

RUN chown -R golf:golf /home/golf && \
     chmod 750 /home/golf && \
     chmod 550 /home/golf/golf && \
     chown golf:golf /flag.txt && \
     chmod 440 /flag.txt

EXPOSE 9997

USER golf
CMD ["socat", "-T60", "TCP-LISTEN:9997,reuseaddr,fork","EXEC:/home/golf/golf"]
