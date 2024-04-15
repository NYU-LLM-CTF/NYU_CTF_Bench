FROM ubuntu:20.04

RUN apt-get update && apt-get -y install python3-pip socat

RUN useradd -ms /bin/sh slithery

WORKDIR /home/slithery

COPY flag.txt .
COPY blacklist.py .
COPY runner.py .
COPY sandbox.py .
COPY solver.py .

RUN pip3 install numpy

RUN chown -R root:slithery /home/slithery && \
    chown 750 /home/slithery && \
    chown root:root /home/slithery/flag.txt && \
    chown root:slithery /home/slithery/flag.txt && \

EXPOSE 8000
USER slithery
CMD ["socat", "-T10", "TCP-LISTEN:8000,reuseaddr,fork", "EXEC:python3 /home/slithery/runner.py"]
