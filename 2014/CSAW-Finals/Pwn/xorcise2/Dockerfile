FROM ubuntu:16.04
MAINTAINER Oskar
LABEL Description="CSAW 2014-F: Xorcise 2" VERSION='1.0'
# Update
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y install libc6-dbg
RUN apt-get -y install libc6-dbg:i386
RUN apt-get -y install lib32stdc++6
# Files
WORKDIR /opt/chal
COPY xorcise /opt/chal/xorcise
COPY flag /opt/chal/flag
COPY config.txt /opt/chal/config.txt
RUN chmod 440 /opt/chal/flag
RUN chmod 777 /opt/chal/config.txt
RUN chmod +x /opt/chal/xorcise
# Execute
EXPOSE 24002
CMD ./xorcise