FROM ubuntu:18.04
MAINTAINER tnek

RUN apt-get update && apt-get install -y socat

RUN useradd -ms /bin/sh baby_boi
WORKDIR /home/baby_boi

COPY ./baby_boi ./
COPY ./flag.txt ./

RUN chown -R root:baby_boi /home/baby_boi && \
     chmod 750 /home/baby_boi && \
     chmod 550 /home/baby_boi/baby_boi && \
     chown root:baby_boi /home/baby_boi/flag.txt && \
     chmod 440 /home/baby_boi/flag.txt

EXPOSE 8000

CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork,su=baby_boi","EXEC:/home/baby_boi/baby_boi"]
