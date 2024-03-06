FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update && apt-get install -y socat python3
RUN groupadd -r ctf && useradd -r -g ctf ctf
RUN chmod 1733 /tmp /var/tmp /dev/shm

WORKDIR /home/ctf


ADD deploy/service.py .
RUN chmod 500 ./service.py
RUN chown ctf:root . -R
ADD deploy/flag.txt .
RUN chmod 444 ./flag.txt


USER ctf
CMD socat TCP-L:9998,fork,reuseaddr EXEC:"python3 ./service.py",pty,stderr,setsid,sane,raw,echo=0
EXPOSE 9998