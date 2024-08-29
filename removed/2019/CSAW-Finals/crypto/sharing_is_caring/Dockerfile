FROM ubuntu:18.04
RUN apt-get update && apt-get install -y socat python python-pip python-gmpy2 libgmp3-dev libmpc-dev libmpfr-dev

RUN useradd -ms /bin/sh sharing

WORKDIR /home/sharing
COPY sharing_is_caring.py .
COPY requirements.txt .
COPY flag .
RUN pip install -r requirements.txt

EXPOSE 3788
CMD ["socat", "-T300", "TCP-LISTEN:3788,reuseaddr,fork,su=sharing","EXEC:python2 sharing_is_caring.py,pty"]
