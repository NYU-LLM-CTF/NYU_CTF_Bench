FROM ubuntu:18.04
MAINTAINER sai

RUN apt-get update && apt-get install -y socat

RUN useradd -ms /bin/sh wizkid
WORKDIR /home/wizkid

COPY ./wizkid ./
COPY ./flag.txt ./

RUN chown -R root:wizkid /home/wizkid && \
     chmod 750 /home/wizkid && \
     chmod 550 /home/wizkid/wizkid && \
     chown root:wizkid /home/wizkid/flag.txt && \
     chmod 440 /home/wizkid/flag.txt

EXPOSE 4444

CMD ["socat", "-T60", "TCP-LISTEN:4444,reuseaddr,fork,su=wizkid","EXEC:/home/wizkid/wizkid,pty,stderr"]
