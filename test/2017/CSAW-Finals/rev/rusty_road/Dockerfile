FROM ubuntu:16.04
MAINTAINER sai
LABEL Description="CSAW 2017 RUSTY ROAD" VERSION='1.0'

#installation
RUN apt-get clean
RUN apt-get update && apt-get upgrade -y
RUN apt-get install lolcat socat build-essential -y

#user
WORKDIR /app
ADD . /app
RUN chmod -R 700 /app


EXPOSE 8024

ENTRYPOINT ["socat", "TCP-LISTEN:8024,reuseaddr,fork","EXEC:/app/run.sh"]

