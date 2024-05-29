FROM python:3.6.6-stretch
MAINTAINER Sai Vegasena

#installation
RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    socat

#user
WORKDIR /app
ADD . /app
RUN chmod -R 700 /app

EXPOSE 4324

ENTRYPOINT ["socat","-T20" ,"TCP-LISTEN:4324,reuseaddr,fork","EXEC:/app/run.sh"]
