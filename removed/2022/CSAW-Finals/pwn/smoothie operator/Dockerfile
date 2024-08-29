FROM ubuntu:20.04
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y socat

RUN useradd -u 5000 -m pwn

WORKDIR /home/pwn
COPY ./public/smoothie_operator ./
COPY ./flag.txt ./

RUN chmod 755 /home/pwn/*
RUN chmod -w /home/pwn

USER pwn
EXPOSE 6666
ENTRYPOINT socat -dd TCP4-LISTEN:6666,fork,reuseaddr EXEC:"/home/pwn/smoothie_operator"

### testing 

# FROM ubuntu:20.04
# RUN apt-get update && apt-get -y upgrade
# RUN apt install python3 -y
# RUN apt install vim -y
# RUN apt install python3-pip -y
# RUN pip3 install pwntools

# COPY ./source/build/smoothie_operator /tmp
# COPY ./flag.txt /tmp
# COPY ./exp/exploit.py /tmp

# RUN chmod 775 /tmp/smoothie_operator