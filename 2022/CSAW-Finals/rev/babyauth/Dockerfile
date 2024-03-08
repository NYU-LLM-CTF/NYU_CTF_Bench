FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y socat python3 python3-pip
RUN groupadd -r ctf && useradd -r -g ctf ctf
RUN chmod 1733 /tmp /var/tmp /dev/shm

WORKDIR /home/ctf

# install deps
ADD requirements.txt .
RUN pip install -r requirements.txt

# setup service
ADD templates/ ./templates
ADD server.py .
ADD validator .
RUN chmod 500 ./server.py
RUN chmod 500 ./validator
RUN chown ctf:root . -R

# flag
ADD flag.txt .
RUN chmod 444 ./flag.txt

USER ctf
CMD ["python3", "server.py"]
EXPOSE 8080
