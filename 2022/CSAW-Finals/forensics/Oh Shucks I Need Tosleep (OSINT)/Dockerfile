
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y socat python3
RUN groupadd -r ctf && useradd -r -g ctf ctf
RUN chmod 1733 /tmp /var/tmp /dev/shm

WORKDIR /home/ctf

ADD server.py .
RUN chmod 500 ./server.py
RUN chown ctf:root . -R
ADD flag.txt .
RUN chmod 444 ./flag.txt

USER ctf
CMD ["socat", "-T300", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:/usr/bin/python3 /home/ctf/server.py,pty,echo=0"]
EXPOSE 5000
