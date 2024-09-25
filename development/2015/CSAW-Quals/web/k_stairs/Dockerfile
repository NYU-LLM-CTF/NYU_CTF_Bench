FROM python:2.7-alpine
MAINTAINER Steven
LABEL Description="CSAW 2015-Q: K_stairs" VERSION='1.0'
# Update
RUN apk update && apk add --no-cache sqlite gcc g++ make libffi-dev openssl-dev
# Files
RUN mkdir -p /root/stairs
COPY arpahack /root/stairs/
WORKDIR /root/stairs
RUN touch game.db
RUN sqlite3 game.db < db.sql
RUN pip install flask pycrypto
# Execute
EXPOSE 4567
CMD ["python", "run.py"]