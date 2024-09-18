FROM ubuntu:20.04

RUN apt-get update && apt-get install -y socat libc6-dev

RUN useradd -ms /bin/sh jackpot

WORKDIR /home/jackpot

COPY jackpot .
COPY flag.txt .

RUN chown -R root:jackpot /home/jackpot && \
    chown root:jackpot /home/jackpot/flag.txt && \
    chmod 440 /home/jackpot/flag.txt && \
    chmod 555 jackpot

USER jackpot
CMD ["socat", "-T270", "TCP-LISTEN:5000,reuseaddr,fork","EXEC:/home/jackpot/jackpot"]
