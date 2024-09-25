FROM ubuntu:16.04
MAINTAINER Oskar
LABEL Description="CSAW 2013-Q: CSAW Diary" VERSION='1.0'
# Update
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y socat build-essential
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y install libc6-dbg
RUN apt-get -y install libc6-dbg:i386
RUN apt-get -y install lib32stdc++6
# User
RUN adduser --disabled-password --gecos '' csaw_diary
RUN chown -R root:csaw_diary /home/csaw_diary/
RUN chmod 750 /home/csaw_diary
RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep
RUN export TERM=xterm
# Files
WORKDIR /home/csaw_diary/
COPY csaw_diary /home/csaw_diary
COPY flag /home/csaw_diary
RUN chown root:csaw_diary /home/csaw_diary/flag
USER csaw_diary
# Execute
EXPOSE 34266
CMD ./csaw_diary