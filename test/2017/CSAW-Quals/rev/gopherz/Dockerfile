FROM ubuntu:16.04
MAINTAINER tnek
LABEL Description="CSAW 2017 gopherz" VERSION='1.0'

#installation
RUN apt-get update && apt-get upgrade -y 
RUN apt-get install -y socat build-essential

#user
RUN adduser --disabled-password --gecos '' gopherz
RUN chmod 750 /home/gopherz

WORKDIR /home/gopherz/

COPY gopherz /home/gopherz
COPY flag.txt /home/gopherz

RUN chown root:gopherz /home/gopherz/flag.txt
RUN chmod 440 /home/gopherz/flag.txt

EXPOSE 7070

CMD su gopherz -c "/home/gopherz/gopherz"
