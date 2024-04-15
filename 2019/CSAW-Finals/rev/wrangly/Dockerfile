FROM ubuntu:18.04

RUN apt-get update && apt-get install -y socat

RUN useradd -ms /bin/sh unwrangle_me
WORKDIR /home/unwrangle_me

COPY ./unwrangle_me .
COPY ./flag.txt .

RUN chown -R root:unwrangle_me /home/unwrangle_me && \
     chmod 750 /home/unwrangle_me && \
     chmod 550 /home/unwrangle_me/unwrangle_me

EXPOSE 8000

CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork,su=unwrangle_me","EXEC:/home/unwrangle_me/unwrangle_me,pty"]
