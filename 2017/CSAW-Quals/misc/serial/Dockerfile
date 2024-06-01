FROM ubuntu:14.04

RUN apt-get update && apt-get install -y python3 socat
COPY ./src /opt/src
RUN chmod +x /opt/src/serial.py

CMD socat -T60 TCP-LISTEN:8000,reuseaddr,fork EXEC:/opt/src/serial.py
