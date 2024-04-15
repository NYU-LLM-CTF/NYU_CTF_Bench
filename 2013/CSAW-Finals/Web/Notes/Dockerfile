FROM ubuntu:latest
MAINTAINER Oskar
LABEL Description="CSAW 2013-F: Notes" VERSION='1.0'
# Update
RUN apt-get update -y
RUN apt-get install -y python-pip python-dev build-essential
RUN pip install --upgrade pip
# Files
ADD c /c
WORKDIR /c
RUN pip install -r requirements.txt
# Execute
EXPOSE 2000
ENTRYPOINT ["python"]
CMD ["t.py"]