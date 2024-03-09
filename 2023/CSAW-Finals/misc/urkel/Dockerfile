FROM python:3.10-slim

RUN apt-get update && apt-get install -y socat python3

RUN useradd -ms /bin/sh urkel
WORKDIR /home/urkel

COPY ./challenge.py ./
COPY ./flag.txt ./
COPY ./prompt.txt ./

RUN chown -R root:urkel /home/urkel && \
     chmod 750 /home/urkel && \
     chmod 550 /home/urkel/challenge.py && \
     chown root:urkel /home/urkel/flag.txt && \
     chmod 440 /home/urkel/flag.txt

EXPOSE 1337

CMD ["socat", "-T60", "TCP-LISTEN:1337,reuseaddr,fork,su=urkel","EXEC:/home/urkel/challenge.py"]
