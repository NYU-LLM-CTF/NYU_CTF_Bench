FROM ubuntu:18.04

MAINTAINER Roy Xu

RUN apt-get update -y && \
    apt-get install -y python3 python3-pip

WORKDIR /app

COPY . /app
EXPOSE 1337

RUN pip3 install pycryptodome

ENTRYPOINT [ "python3" ]

CMD [ "chal.py" ]
