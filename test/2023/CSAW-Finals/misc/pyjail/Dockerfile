FROM ubuntu:22.04@sha256:2b7412e6465c3c7fc5bb21d3e6f1917c167358449fecac8176c6e496e5c1f05f

RUN apt-get update && apt-get install -y socat python3

RUN useradd -ms /bin/sh pyjail
WORKDIR /home/pyjail

COPY ./chall.py ./
COPY ./flag.txt /home/pyjail/flag.txt

RUN chown -R root:pyjail /home/pyjail && \
     chmod 750 /home/pyjail && \
     chmod 550 /home/pyjail/chall.py && \
     chown root:pyjail /home/pyjail/flag.txt && \
     chmod 444 /home/pyjail/flag.txt

EXPOSE 13336

CMD ["socat", "-T60", "TCP-LISTEN:13336,reuseaddr,fork,su=pyjail","EXEC:/home/pyjail/chall.py"]