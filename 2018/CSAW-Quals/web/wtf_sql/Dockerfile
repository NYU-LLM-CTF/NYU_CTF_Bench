FROM mysql

RUN apt-get update && apt-get install -y \
    python \
    python-dev \
    python-pip \
    gcc

RUN pip install uwsgi PyMySql

COPY start.sh /docker-entrypoint-initdb.d/
COPY app.sql /docker-entrypoint-initdb.d/
COPY server.py /
