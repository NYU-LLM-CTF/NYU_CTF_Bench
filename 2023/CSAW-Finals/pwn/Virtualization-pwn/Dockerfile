FROM ubuntu:18.04

RUN apt-get update && apt-get install -y socat

RUN useradd -ms /bin/sh virtualization
WORKDIR /home/virtualization

COPY ./prog ./
COPY ./flag.txt /home/virtualization/flag.txt

RUN chown -R root:virtualization /home/virtualization && \
     chmod 750 /home/virtualization && \
     chmod 550 /home/virtualization/prog && \
     chown root:virtualization /home/virtualization/flag.txt && \
     chmod 444 /home/virtualization/flag.txt

EXPOSE 20001

CMD ["socat", "-T60", "TCP-LISTEN:20001,reuseaddr,fork,su=virtualization","EXEC:/home/virtualization/prog"]