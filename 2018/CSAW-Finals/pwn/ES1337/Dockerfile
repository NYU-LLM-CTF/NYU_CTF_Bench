FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y gnupg2 curl vim wget

COPY server /server

WORKDIR /server

RUN apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add the docker repository
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable"
RUN apt-get update
RUN apt-get install -y docker-ce

CMD ["/server/run.sh"]
