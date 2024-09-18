FROM ubuntu:18.04

RUN dpkg --add-architecture i386

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y socat libstdc++6:i386

RUN useradd -ms /bin/sh buser

WORKDIR /home/buser


COPY ./flag.txt ./
COPY ./a.out ./
RUN chown -R root:buser /home/buser && \
    chmod 750 /home/buser && \
    chown root:buser /home/buser/flag.txt && \
    chmod 440 /home/buser/flag.txt

EXPOSE 8000
CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork,su=buser", "EXEC:/home/buser/a.out"]
