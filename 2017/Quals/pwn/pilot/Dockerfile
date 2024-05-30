FROM ubuntu:16.04
MAINTAINER unknonwn
LABEL Description="CSAW 2017 PILOT" VERSION='1.0'

#installation
RUN apt-get update && apt-get upgrade -y 
RUN apt-get install -y socat build-essential

#user
RUN adduser --disabled-password --gecos '' pilot
RUN chown -R root:pilot /home/pilot/
RUN chmod 750 /home/pilot
RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep
RUN export TERM=xterm

WORKDIR /home/pilot/

COPY pilot.cpp /home/pilot
COPY flag /home/pilot

RUN chown root:pilot /home/pilot/flag
RUN chmod 440 /home/pilot/flag
RUN g++ -std=c++11 -fno-stack-protector -z execstack pilot.cpp -o pilot
RUN strip -s pilot
RUN rm pilot.cpp

EXPOSE 8024
CMD su pilot -c "socat -T10 TCP-LISTEN:8024,reuseaddr,fork EXEC:/home/pilot/pilot"
 
