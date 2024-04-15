FROM ubuntu:18.04

RUN apt-get update && apt-get -y install python3-pip socat

RUN useradd -ms /bin/sh adversarial

WORKDIR /home/adversarial/

COPY flag.txt .
COPY server.py .

RUN chown -R root:adversarial /home/adversarial && \
    chmod 750 /home/adversarial && \
    chown root:adversarial /home/adversarial/flag.txt && \
    chmod 440 /home/adversarial/flag.txt && \
    chown root:adversarial /home/adversarial/server.py && \
    chmod 750 /home/adversarial/server.py

RUN pip3 install pycrypto

EXPOSE 8000
CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork,su=adversarial", "EXEC:python3 /home/adversarial/server.py,STDERR,pty,echo=0"]
