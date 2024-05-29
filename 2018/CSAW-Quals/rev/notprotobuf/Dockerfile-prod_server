FROM ubuntu:18.04
LABEL maintainer austin.ralls@carvesystems.com

RUN mkdir -p /opt/ctf/
WORKDIR /opt/ctf

RUN apt-get update && apt-get install -y python3.7 python3-sqlalchemy python3-openssl python3-pil python3-construct

ENV PORT=51966 FLAG="flag{We don't make mistakes. We just have happy accidents}" PROD=1
EXPOSE 51966
COPY CSLLC_Logo_Block.png initialize.py library.py server.py ./

RUN python3 initialize.py

CMD python3 server.py
