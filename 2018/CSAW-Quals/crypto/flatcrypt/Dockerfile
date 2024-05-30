FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y python3 python3-pip
RUN apt-get install -y socat
RUN pip3 install pycrypto

COPY /serv.py /

EXPOSE 8040

#CMD ["socat", "-T10", "TCP-LISTEN:8040,reuseaddr,fork", "EXEC:'python3 /serv.py'"]
CMD ["socat",  "TCP-LISTEN:8040,reuseaddr,fork", "EXEC:'python3 /serv.py'"]

