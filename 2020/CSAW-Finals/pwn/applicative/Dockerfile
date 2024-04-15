FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y socat libstdc++6

RUN useradd -ms /bin/sh applicative

WORKDIR /home/applicative


COPY ./flag.txt ./
COPY ./applicative ./
RUN chown -R root:applicative /home/applicative && \
    chmod 750 /home/applicative && \
    chown root:applicative /home/applicative/flag.txt && \
    chmod 440 /home/applicative/flag.txt

CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork,su=applicative", "EXEC:/home/applicative/applicative"]
