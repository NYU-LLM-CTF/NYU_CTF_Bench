FROM ubuntu:20.04

RUN sed -i "s/http:\/\/archive.ubuntu.com/http:\/\/mirror.yandex.ru/g" /etc/apt/sources.list
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -y lib32z1 xinetd python3

RUN useradd -m ctf

WORKDIR /home/ctf

RUN cp -R /usr/lib* /home/ctf

RUN mkdir /home/ctf/dev
RUN mknod /home/ctf/dev/null c 1 3
RUN mknod /home/ctf/dev/zero c 1 5
RUN mknod /home/ctf/dev/random c 1 8
RUN mknod /home/ctf/dev/urandom c 1 9
RUN chmod 666 /home/ctf/dev/*

#RUN mkdir /home/ctf/bin
#RUN cp /bin/sh /home/ctf/bin
#RUN cp /bin/ls /home/ctf/bin
#RUN cp /bin/cat /home/ctf/bin

COPY source/docker/ctf.xinetd /etc/xinetd.d/ctf
RUN echo "Blocked by ctf_xinetd" > /etc/banner_fail
RUN echo "export TERM=xterm" >> ~/.bashrc

COPY source/docker/bin/ /home/ctf/
RUN chown -R root:ctf /home/ctf
RUN chmod -R 750 /home/ctf
RUN chmod 744 /home/ctf/flag-2b5d1322-519b-4abe-a5a3-b0717f37ccd6.txt

CMD exec /bin/sh -c "/etc/init.d/xinetd start; trap : TERM INT; sleep infinity & wait"


EXPOSE 9999

