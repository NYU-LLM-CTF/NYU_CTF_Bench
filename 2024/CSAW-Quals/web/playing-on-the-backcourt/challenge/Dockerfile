#syntax=docker/dockerfile:1

FROM python:3.8-slim-buster

RUN apt-get update && apt-get install -y cron

RUN pip3 install gunicorn

WORKDIR /app

COPY requirements.txt ./


RUN useradd -m swilliams


RUN pip3 install -r requirements.txt

COPY ./ ./
RUN mkdir logs && chmod 777 logs
RUN echo "*/10 * * * * truncate -s 0 /app/logs/ -type f -exec truncate -s 0 {} \;" > /etc/cron.d/log-prune
RUN chmod 0644 /etc/cron.d/log-prune
RUN crontab /etc/cron.d/log-prune

ENV FLASK_APP=app

EXPOSE 5000


CMD ["sh", "-c", "cron  && su -c 'gunicorn -b 0.0.0.0:5000 -w 1 app:app' swilliams"]
