FROM ubuntu:16.04
MAINTAINER Oskar
LABEL Description="CSAW 2014-F: Mbot" VERSION='1.0'
# Update
RUN apt-get update && apt-get upgrade -y
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y install libc6-dbg
RUN apt-get -y install libc6-dbg:i386
RUN apt-get -y install lib32stdc++6
RUN apt-get -y install libcurl3:i386
# Files
WORKDIR /opt/mbot/
COPY mbot /opt/mbot/mbot
COPY key /opt/mbot/flag
RUN chmod 440 /opt/mbot/flag
RUN chmod +x /opt/mbot/mbot
# Execute
EXPOSE 6247
CMD ./mbot -p 6247