FROM ubuntu:16.04
MAINTAINER Oskar
LABEL Description="CSAW 2013-Q: Exploitation 1" VERSION='1.0'
# Update
RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install \
    libffi-dev \
    libssl-dev \
    python \
    python-dev \
    python-pip
# Files
ADD challenge /app
WORKDIR /app
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
# Execute
EXPOSE 80
CMD ./run.sh