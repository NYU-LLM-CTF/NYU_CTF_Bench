# Don't use this as a template plz

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y socat python3

RUN useradd -ms /bin/sh chal
WORKDIR /home/chal

COPY ./challenge.py ./

EXPOSE 31137

CMD ["socat", "-T60", "TCP-LISTEN:31137,reuseaddr,fork,su=chal","EXEC:python3 /home/chal/challenge.py"]
