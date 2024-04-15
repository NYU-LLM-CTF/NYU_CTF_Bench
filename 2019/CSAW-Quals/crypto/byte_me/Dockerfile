FROM ubuntu:16.04

RUN apt-get update && apt-get install -y socat python python-pip
RUN pip install --upgrade pip
RUN pip install pycrypto

COPY generator.py ./generator.py

EXPOSE 8000

CMD ["socat", "TCP-LISTEN:8000,fork,reuseaddr", "EXEC:python generator.py,pty,stderr"]
