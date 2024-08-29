FROM ubuntu:18.04

RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev libgmp3-dev libmpfr-dev libmpc-dev

COPY flag /app/flag
COPY server.py /app/server.py
COPY requirements.txt /app/requirements.txt

EXPOSE 23333
WORKDIR /app

RUN pip3 install -r requirements.txt

ENTRYPOINT ["python3"]
CMD ["server.py"]
