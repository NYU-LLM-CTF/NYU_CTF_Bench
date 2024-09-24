FROM python:3-slim

RUN apt-get update && apt-get -y install socat iverilog

WORKDIR /opt/chal/
COPY flag.hex .
COPY server.py .
COPY ncore_tb.v .
RUN iverilog -g2012 -o nco ncore_tb.v \
  && useradd chal \
  && chown chal -R /opt/chal

USER chal
CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,pktinfo,fork,ignoreeof", "EXEC:python3 server.py"]
