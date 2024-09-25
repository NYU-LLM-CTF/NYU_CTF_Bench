FROM ubuntu:14.04

RUN apt-get update && apt-get upgrade -y

ARG PYTHON_VERSION=2.7.9

# Install dependencies
RUN apt-get update \
  && apt-get install -y wget gcc make openssl libffi-dev libgdbm-dev libsqlite3-dev libssl-dev zlib1g-dev \
  && apt-get clean

WORKDIR /tmp/

# Build Python from source
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
# no tty
ENV DEBIAN_FRONTEND=noninteractive

# global installs [applies to all envs!]
# RUN apt-get install -y python python-pip python-dev
RUN pip2 install Twisted


WORKDIR /opt/sleeping/
COPY ./sleeping.py /opt/sleeping/
COPY ./sleeping.png /opt/sleeping/

EXPOSE 8000
CMD ["python", "./sleeping.py"]
