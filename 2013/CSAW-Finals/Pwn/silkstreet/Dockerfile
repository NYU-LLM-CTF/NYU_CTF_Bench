FROM ubuntu:16.04
MAINTAINER Oskar
LABEL Description="CSAW 2013-F: Silk Street" VERSION='1.0'
# Update
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y socat build-essential
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y install libc6-dbg
RUN apt-get -y install libc6-dbg:i386
RUN apt-get -y install lib32stdc++6
# User
RUN adduser --disabled-password --gecos '' silkstreet
RUN chown -R root:silkstreet /home/silkstreet/
RUN chmod 750 /home/silkstreet
RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep
RUN export TERM=xterm
# Files
WORKDIR /home/silkstreet/
COPY silkstreet /home/silkstreet
COPY flag /home/silkstreet
# Execute
EXPOSE 8000 
ENTRYPOINT ["socat", "TCP-LISTEN:8000,reuseaddr,fork","EXEC:/home/silkstreet/silkstreet"]