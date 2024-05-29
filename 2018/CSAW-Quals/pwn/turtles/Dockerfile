FROM debian:8.0
MAINTAINER breadchris
LABEL Description="CSAW 2018 TURTLES" VERSION='1.0'

#installation
RUN apt-get update && apt-get upgrade -y 
RUN apt-get install -y socat

#user
RUN adduser --disabled-password --gecos '' turtles
RUN chown -R root:turtles /home/turtles/
RUN chmod 750 /home/turtles
RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep

WORKDIR /home/turtles/

COPY libs/ /home/turtles/libs
COPY turtles /home/turtles
COPY flag /home/turtles

RUN chown root:turtles /home/turtles/flag
RUN chmod 440 /home/turtles/flag

ENV LD_LIBRARY_PATH "/home/turtles/libs"

EXPOSE 8024
CMD ["socat", "-T60", "TCP-LISTEN:8024,reuseaddr,fork,su=turtles", "EXEC:/home/turtles/turtles"]
