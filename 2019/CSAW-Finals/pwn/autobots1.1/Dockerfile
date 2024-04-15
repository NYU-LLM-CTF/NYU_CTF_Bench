FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y socat
RUN apt-get install -y python
RUN apt-get install -y build-essential
RUN apt-get install -y gcc

RUN adduser --disabled-password --gecos '' autobots

WORKDIR /home/autobots

RUN chown -R root:autobots /home/autobots/
RUN chmod 750 /home/autobots

COPY . /home/autobots

RUN chmod 750 /home/autobots/bof.c
RUN chmod 750 /home/autobots/bof_small.c
RUN chmod 750 /home/autobots/autobots1.1.py

RUN chown root:autobots /home/autobots/flag.txt
RUN chmod 440 /home/autobots/flag.txt

EXPOSE 8888
EXPOSE 8677-8887

CMD ["python", "/home/autobots/autobots1.1.py"]
