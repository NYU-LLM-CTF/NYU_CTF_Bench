FROM ubuntu:18.04

RUN apt -y update && apt -y upgrade && apt -y install python-dev libssl-dev libffi-dev socat python-pip

WORKDIR /opt
COPY ./requirements.txt ./
RUN pip install -r requirements.txt

COPY ./brillouin.py ./
COPY ./flag.txt ./

EXPOSE 8000
CMD ["socat", "-T10", "TCP-LISTEN:8000,reuseaddr,fork", "EXEC:python /opt/brillouin.py,STDERR,pty,echo=0"]