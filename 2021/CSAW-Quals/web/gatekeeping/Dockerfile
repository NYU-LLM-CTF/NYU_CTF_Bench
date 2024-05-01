FROM python:3.8

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y nginx \
  && pip3 install pycrypto supervisor \
    flask==2.0.1 gunicorn==20.1.0 Werkzeug==2.0.1 Jinja2==3.0.1 click==8.0.1 itsdangerous==2.0.1 MarkupSafe==2.0.1 certifi==2021.5.30 \
  && useradd -m app

COPY supervisord.conf /supervisord.conf
COPY server/ /server
RUN "/server/setup.sh"

RUN chmod a-w -R /server

CMD ["supervisord", "-c", "/supervisord.conf"]
