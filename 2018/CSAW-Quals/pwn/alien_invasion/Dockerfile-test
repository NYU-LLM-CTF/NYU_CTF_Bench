FROM ubuntu:16.04
MAINTAINER Sai Vegasena

#installation
RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    socat

WORKDIR /app

COPY ./ ./

RUN make test

CMD ["test"]