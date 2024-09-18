FROM ubuntu:16.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y socat gcc-multilib

#user
RUN adduser --disabled-password --gecos '' gotmilk
RUN chown -R root:gotmilk /home/gotmilk/
RUN chmod 750 /home/gotmilk
RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep

WORKDIR /home/gotmilk

COPY dist/gotmilk ./
RUN mkdir -p /home/gotmilk/libs/
COPY dist/libmylib.so /home/gotmilk/libs/

COPY flag.txt ./flag.txt

RUN chown root:gotmilk /home/gotmilk/flag.txt
RUN chmod 440 /home/gotmilk/flag.txt

ENV LD_LIBRARY_PATH "/home/gotmilk/libs"

EXPOSE 8000
CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork,su=gotmilk", "EXEC:/home/gotmilk/gotmilk"]
