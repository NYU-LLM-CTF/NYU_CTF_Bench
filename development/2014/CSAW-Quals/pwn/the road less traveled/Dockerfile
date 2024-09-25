FROM ubuntu:16.04
MAINTAINER Steven
LABEL Description="CSAW 2014-Q: The Road Less Traveled" VERSION=1.0

RUN dpkg --add-architecture i386 && apt-get update && apt-get -y upgrade && \
    apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 build-essential

RUN mkdir -p /root/road
WORKDIR /root/road
COPY . .

RUN cd bo && make

RUN chmod 750 /root/road/bo/bo

CMD ["./bo/bo"]
EXPOSE 1515
