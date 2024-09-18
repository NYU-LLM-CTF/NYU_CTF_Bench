FROM python:3.6

EXPOSE 5000

RUN mkdir /app
WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y build-essential cmake

COPY pip-freeze.txt /app/pip-freeze.txt
RUN pip install --upgrade pip
RUN pip install -r pip-freeze.txt

COPY . /app

CMD python main.py
