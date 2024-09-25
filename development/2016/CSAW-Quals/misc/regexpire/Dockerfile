FROM ubuntu:14.04
MAINTAINER unknonwn
LABEL Description="CSAW 2016 Regexpire" VERSION='1.0'

#installation
RUN apt-get update && apt-get upgrade -y

ARG PYTHON_VERSION=2.7.9

RUN apt-get update \
  && apt-get install -y wget gcc make openssl libffi-dev libgdbm-dev libsqlite3-dev libssl-dev zlib1g-dev build-essential socat\
  && apt-get clean

WORKDIR /tmp/

RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
  && tar --extract -f Python-$PYTHON_VERSION.tgz \
  && cd ./Python-$PYTHON_VERSION/ \
  && ./configure --with-ensurepip=install --enable-optimizations --prefix=/usr/local \
  && make && make install \
  && cd ../ \
  && rm -r ./Python-$PYTHON_VERSION*

# keep upstart quiet
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl
RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py \
    && python get-pip.py

#user
WORKDIR /opt
COPY ./regexpire.py /opt/regexpire.py
RUN chmod +x /opt/regexpire.py

CMD socat -T60 TCP-LISTEN:8000,reuseaddr,fork EXEC:"python ./regexpire.py"
