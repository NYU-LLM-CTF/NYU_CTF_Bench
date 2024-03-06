FROM ubuntu:22.04

RUN apt-get update && apt-get install -y socat

RUN useradd -ms /bin/sh target_practice
WORKDIR /home/target_practice

COPY ./target_practice ./
COPY ./flag.txt /

RUN chown -R root:target_practice /home/target_practice && \
     chmod 750 /home/target_practice && \
     chmod 550 /home/target_practice/target_practice && \
     chown root:target_practice /flag.txt && \
     chmod 440 /flag.txt

EXPOSE 31138

CMD ["socat", "-T60", "TCP-LISTEN:31138,reuseaddr,fork,su=target_practice","EXEC:/home/target_practice/target_practice"]
