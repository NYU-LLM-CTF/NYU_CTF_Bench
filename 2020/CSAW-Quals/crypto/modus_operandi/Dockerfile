FROM ubuntu:18.04

RUN apt-get update && apt-get -y install python3 python3-pip socat

RUN useradd -ms /bin/sh modus

WORKDIR /home/modus
COPY flag.txt .
COPY encrypt.py .

RUN chown -R root:modus /home/modus && \
    chmod 750 /home/modus && \
    chown root:modus /home/modus/flag.txt && \
    chmod 440 /home/modus/flag.txt && \
    chown root:modus /home/modus/encrypt.py && \
    chmod 750 /home/modus/encrypt.py

RUN pip3 install pycrypto

EXPOSE 8000
USER modus
CMD ["socat", "-T200", "TCP-LISTEN:8000,reuseaddr,fork,ignoreeof", "EXEC:python3 /home/modus/encrypt.py"]
