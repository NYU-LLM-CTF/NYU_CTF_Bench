FROM debian:8.0
MAINTAINER breadchris
LABEL Description="CSAW 2018 PGTP" VERSION='1.0'

#installation
RUN sed -i 's/httpredir.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN sed -i 's/httpredir.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN sed -i '/jessie[/-]updates/d' /etc/apt/sources.list
RUN sed -i 's/^deb /deb [trusted=yes] /' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y socat

#user
RUN adduser --disabled-password --gecos '' pgtp
RUN chown -R root:pgtp /home/pgtp/
RUN chmod 750 /home/pgtp
RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep

WORKDIR /home/pgtp/

COPY libs/ /home/pgtp/libs
COPY pgtp /home/pgtp
COPY flag.txt /home/pgtp

RUN chown root:pgtp /home/pgtp/flag.txt
RUN chmod 440 /home/pgtp/flag.txt

ENV LD_LIBRARY_PATH "/home/pgtp/libs"

EXPOSE 28201
CMD su pgtp -c "socat -T10 TCP-LISTEN:28201,reuseaddr,fork EXEC:/home/pgtp/pgtp"
