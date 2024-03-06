FROM python:3.8-slim
# FROM ubuntu:20.04

RUN apt-get update \
    && apt-get install procps sudo python3-pip -y \
    && groupadd ctf \
    && useradd -r -g ctf ctf

USER root

RUN mkdir /app
RUN chmod 755 /app
RUN chown root:root /app

RUN cp -R /lib* /app && \
    mkdir /app/usr && \
    cp -R /usr/lib* /app/usr

RUN mkdir /app/usr/local && \
    #cp -R /usr/local/lib* /app/usr/local && \
    cp -R /usr/local/lib* /app/usr

RUN mkdir /app/dev && \
    mknod /app/dev/null c 1 3 && \
    mknod /app/dev/zero c 1 5 && \
    mknod /app/dev/random c 1 8 && \
    mknod /app/dev/urandom c 1 9 && \
    chmod 666 /app/dev/*

RUN mkdir /app/bin && \
    cp /bin/sh /app/bin && \
    cp /bin/ls /app/bin && \
    cp /bin/cat /app/bin



WORKDIR /app

COPY requirements.txt ./requirements.txt

COPY src/bot.py src/flag.txt src/settings.py ./

RUN pip install -r requirements.txt

RUN chmod 700 ./bot.py && chmod 700 ./settings.py && chmod 444 ./flag.txt && chown root:root . -R && chmod 444 ./flag.txt

RUN mkdir interpret

RUN python3 -m venv --copies interpret

CMD ["python3", "/app/bot.py"]
