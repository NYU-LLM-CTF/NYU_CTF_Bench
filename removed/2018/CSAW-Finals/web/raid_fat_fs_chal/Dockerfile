FROM ubuntu:14.04

RUN apt-get update -y
RUN apt-get install -y python dosfstools

WORKDIR /ctf_web

COPY ctf_web /ctf_web
RUN mkdir public_html

EXPOSE 5000
CMD /usr/bin/python http_server.py
