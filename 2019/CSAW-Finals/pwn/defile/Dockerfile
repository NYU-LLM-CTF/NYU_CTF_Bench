FROM ubuntu:18.04

RUN dpkg --add-architecture i386

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y socat libstdc++6:i386

RUN useradd -ms /bin/sh defile

WORKDIR /home/defile


COPY ./flag.txt ./
COPY ./defile ./
RUN chown -R root:defile /home/defile && \
    chmod 750 /home/defile && \
    chown root:defile /home/defile/flag.txt && \
    chmod 440 /home/defile/flag.txt

EXPOSE 8000

CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork,su=defile", "EXEC:/home/defile/defile,stderr"]
