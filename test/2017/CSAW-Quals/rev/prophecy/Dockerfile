FROM ubuntu:16.04
MAINTAINER unknonwn
LABEL Description="CSAW 2017 PROPHECY" VERSION='1.0'

#installation
RUN apt-get clean
RUN apt-get -qq update && apt-get upgrade -y 
RUN apt-get install -y socat build-essential python-pip

#user
RUN adduser --disabled-password --gecos '' prophecy 
RUN chown -R root:prophecy /home/prophecy/
RUN chmod 750 /home/prophecy
RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep
RUN export TERM=xterm

WORKDIR /home/prophecy/

COPY prophecy /home/prophecy
COPY flag /home/prophecy

RUN chown root:prophecy /home/prophecy/flag
RUN chmod 440 /home/prophecy/flag

EXPOSE 8027
CMD su prophecy -c "socat -T10 TCP-LISTEN:8027,reuseaddr,fork EXEC:/home/prophecy/prophecy"
 
