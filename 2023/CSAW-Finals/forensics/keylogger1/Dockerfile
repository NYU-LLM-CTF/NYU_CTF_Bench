#syntax=docker/dockerfile:1

FROM python:3.8-slim-buster

WORKDIR /python-docker

COPY requirements.txt requirements.txt
COPY ./templates/form.html ./templates/form.html
RUN pip3 install -r requirements.txt

RUN export FLASK_APP=app


COPY . .


CMD ["gunicorn", "-b", "0.0.0.0:4999", "-w 8", "app:app", "&"]

