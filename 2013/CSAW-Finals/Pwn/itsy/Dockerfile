FROM ubuntu:16.04
MAINTAINER Oskar
LABEL Description="CSAW 2013-F: Itsy" VERSION='1.0'
# Update
RUN apt-get update && apt-get upgrade -y
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y install libc6-dbg
RUN apt-get -y install libc6-dbg:i386
RUN apt-get -y install lib32stdc++6
RUN apt-get -y install ruby
RUN gem update --system 
# User
RUN adduser --disabled-password --gecos '' itsy
RUN chown -R root:root /home/itsy/
RUN chmod 750 /home/itsy
RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep
RUN export TERM=xterm
# Files
WORKDIR /home/itsy/
COPY server-source/itsy /home/itsy
COPY key /home/itsy
#this is where the challenge needs more work, it isn't accepting connections properly
RUN chown root:root /home/itsy/key
RUN chown root:root /home/itsy/
RUN chown root:root /home/itsy/itsy
RUN chmod 0750 /home/itsy/itsy
RUN chmod 0640 /home/itsy
RUN chmod 0640 /home/itsy/key
# Execute
EXPOSE 11586
CMD ./itsy