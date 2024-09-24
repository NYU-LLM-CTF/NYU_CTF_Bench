FROM ubuntu:18.04
MAINTAINER tnek

RUN apt-get update && apt-get install -y socat python3 python3-pip

RUN useradd -ms /bin/sh mystery_boi
WORKDIR /home/mystery_boi

RUN pip3 install requests
COPY ./distribute/* ./


RUN chown -R root:mystery_boi /home/mystery_boi && \
     chmod -R 440 /home/mystery_boi/* && \
     chmod 750 /home/mystery_boi && \
     chmod 550 /home/mystery_boi/mystery_boi && \
     chmod 550 /home/mystery_boi/launcher.py

EXPOSE 8000

CMD ["socat", "-T60", "-b524288", "TCP-LISTEN:8000,reuseaddr,fork,su=mystery_boi","EXEC:python3 launcher.py,pty,stderr"]
