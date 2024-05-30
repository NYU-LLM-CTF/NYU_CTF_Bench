FROM ubuntu:16.04

RUN apt-get update && apt-get install -y socat build-essential

RUN adduser --disabled-password --gecos '' zone
RUN chown -R root:zone /home/zone/
RUN chmod 750 /home/zone
RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep
RUN export TERM=xterm

COPY flag /home/zone
COPY zone /home/zone

RUN chown root:zone /home/zone/flag
RUN chmod 440 /home/zone/flag

WORKDIR /home/zone/

EXPOSE 8000
CMD su zone -c "socat -T10 TCP-LISTEN:8000,reuseaddr,fork EXEC:/home/zone/zone"
