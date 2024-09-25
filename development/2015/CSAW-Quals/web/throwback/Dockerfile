FROM python:2.7-alpine
MAINTAINER Steven
LABEL Description="CSAW 2015-Q: Throwback" VERSION='1.0'
# Update
RUN apk update && apk upgrade && apk add python-dev libffi-dev gcc make musl-dev mysql-client
# Files
RUN mkdir -p /root/throwback
ADD CTFd /root/throwback
WORKDIR /root/throwback
RUN pip install -r requirements.txt
# Execute
CMD ["python", "serve.py"]
EXPOSE 4000