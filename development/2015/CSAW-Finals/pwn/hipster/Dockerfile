FROM ubuntu:16.04
MAINTAINER Oskar
LABEL Description="CSAW 2015-F: Hipster Hitler" VERSION='1.0'
# Update
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y socat build-essential
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y install libc6-dbg
RUN apt-get -y install libc6-dbg:i386
RUN apt-get -y install lib32stdc++6
# User
RUN adduser --disabled-password --gecos '' hipster
RUN chown -R root:hipster /home/hipster/
RUN chmod 750 /home/hipster
RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep
RUN export TERM=xterm
# Files
WORKDIR /home/hipster/
COPY hipster /home/hipster
COPY flag /home/hipster
RUN chown root:hipster /home/hipster/flag
RUN chmod 440 /home/hipster/flag
RUN chmod +x /home/hipster/hipster
# Execute
EXPOSE 8025
CMD su hipster -c "socat -T10 TCP-LISTEN:8025,reuseaddr,fork EXEC:/home/hipster/hipster"