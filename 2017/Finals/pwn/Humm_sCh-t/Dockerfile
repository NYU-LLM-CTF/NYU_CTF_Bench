FROM ubuntu:artful
MAINTAINER elyk
LABEL Description="YummyYummyHumm_s" VERSION='yum'

#installation
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install sl build-essential libncurses5 libncurses5-dev socat -y

#user
WORKDIR /chit
COPY serve /chit/serve
COPY flag.txt /chit/flag.txt
RUN chmod -R 440 /chit/flag.txt
RUN chmod -R 2755 /chit/serve

EXPOSE 4242

ENTRYPOINT ["/chit/serve"]

#docker build -t "zestylemonsserver" .; docker run -it zestylemonsever
