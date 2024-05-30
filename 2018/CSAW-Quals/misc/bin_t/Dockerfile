FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y 
RUN apt-get install -y socat python-dev python

RUN useradd -ms /bin/sh bin_t

WORKDIR /home/bin_t

ADD . ./

EXPOSE 8000

USER bin_t
CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork", "EXEC:/home/bin_t/tree.py,pty,stderr"]
