FROM ubuntu:16.04
MAINTAINER Oskar
LABEL Description="CSAW 2014-F: Krakme" VERSION='1.0'
# Update
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential qemu netcat
# Files
WORKDIR /opt/chal/
COPY kernel /opt/chal/
COPY rootfs.ext2 /opt/chal/
COPY run.sh /opt/chal/
COPY run2.sh /opt/chal/
# Execute
EXPOSE 9999 
CMD ./run.sh