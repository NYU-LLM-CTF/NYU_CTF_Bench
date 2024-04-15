# docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --rm -it -v $PWD:/whatever mqttdebug bash
FROM debian:stretch
RUN echo deb http://ftp.us.debian.org/debian/ stretch main > /etc/apt/sources.list
RUN echo deb http://archive.debian.org/debian wheezy-backports main >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y build-essential mlocate libc++-dev  g++-multilib g++ socat

RUN mkdir /opt/chal
WORKDIR /opt/chal
COPY ./flag ./
COPY ./mqtt_strip ./
RUN chmod 444 flag && chmod 555 mqtt_strip

USER nobody
CMD ["socat", "-T30", "TCP-LISTEN:5000,reuseaddr,fork","EXEC:./mqtt_strip"]
