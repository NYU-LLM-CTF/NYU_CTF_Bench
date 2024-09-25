FROM ubuntu:16.04
MAINTAINER Oskar
LABEL Description="CSAW 2013-Q: Slurp" VERSION='1.0'
# Update
RUN apt-get update && apt-get -y upgrade && apt-get install -y python socat
# Files
COPY ./slurpServer.py /opt/slurpServer.py
RUN chmod +x /opt/slurpServer.py
# Execute
EXPOSE 8000
CMD python /opt/slurpServer.py