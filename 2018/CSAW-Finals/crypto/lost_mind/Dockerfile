FROM ubuntu:18.04

RUN apt-get update -y && \
    apt-get install -y python-pip python-dev

COPY flag /app/flag
COPY server.py /app/server.py
COPY requirements.txt /app/requirements.txt

EXPOSE 32333
WORKDIR /app

RUN pip install -r requirements.txt

ENTRYPOINT ["python"]
CMD ["server.py"]
