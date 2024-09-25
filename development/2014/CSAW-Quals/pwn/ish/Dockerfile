FROM ubuntu:16.04
MAINTAINER Steven

RUN mkdir -p /root/ish
WORKDIR /root/ish

COPY ish .

RUN dpkg --add-architecture i386
RUN apt-get -y update && apt-get -y upgrade && \
	apt-get -y install  libc6:i386 libncurses5:i386 libstdc++6:i386

CMD ["./ish"]
EXPOSE 9988
