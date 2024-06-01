FROM ubuntu:14.04

RUN apt-get update && apt-get install -y python3 socat
COPY ./credit.py /opt/credit.py
COPY ./flag.txt /opt/flag.txt
RUN chmod +x /opt/credit.py

CMD socat -T60 TCP-LISTEN:8000,reuseaddr,fork EXEC:/opt/credit.py
