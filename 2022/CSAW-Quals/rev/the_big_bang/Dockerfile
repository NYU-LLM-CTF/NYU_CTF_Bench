FROM python:slim

RUN apt-get update && apt-get install -y socat

WORKDIR /opt/chal

COPY flag.txt .
COPY server.py .

RUN useradd chal && chown chal -R /opt/chal
 
USER chal

CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:python3 server.py"]
