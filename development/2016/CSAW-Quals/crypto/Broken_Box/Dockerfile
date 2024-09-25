FROM ubuntu:14.04

ARG PYTHON_VERSION=2.7.9
RUN apt-get update \
  && apt-get install -y wget gcc make openssl libffi-dev libgdbm-dev libsqlite3-dev libssl-dev zlib1g-dev \
  && apt-get clean

WORKDIR /tmp/

RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
  && tar --extract -f Python-$PYTHON_VERSION.tgz \
  && cd ./Python-$PYTHON_VERSION/ \
  && ./configure --with-ensurepip=install --enable-optimizations --prefix=/usr/local \
  && make && make install \
  && cd ../ \
  && rm -r ./Python-$PYTHON_VERSION*

RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py \
  && python get-pip.py

WORKDIR /opt/brokenbox

COPY ./broken_box.py ./

CMD ["python", "./broken_box.py"]

# EXPOSE 31137