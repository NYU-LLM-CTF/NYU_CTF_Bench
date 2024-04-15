FROM ubuntu:14.04
MAINTAINER Oskar
LABEL Description="CSAW 2014-F: Mountain Sound" VERSION='1.0'
# Update
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y python build-essential 
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y install libc6-dbg
RUN apt-get -y install libc6-dbg:i386
RUN apt-get -y install lib32stdc++6
# User
RUN adduser --disabled-password --gecos '' mountainsound
RUN chown -R root:mountainsound /home/mountainsound/
RUN chmod 750 /home/mountainsound
RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep
RUN export TERM=xterm
# Files
COPY key /home/mountainsound/key
RUN chown root:root /home/mountainsound/key
RUN chmod 644 /home/mountainsound/key
ADD dist /home/ubuntu/
WORKDIR /home/ubuntu/
# Execute
EXPOSE 10001
CMD ./mountainsound