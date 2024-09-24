FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y socat python3 && apt-get -y upgrade python

#user
RUN adduser --disabled-password --gecos '' callsite
RUN chown -R root:callsite /home/callsite/
RUN chmod 750 /home/callsite
RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep

WORKDIR /home/callsite

COPY callsite ./
COPY flag.txt ./flag.txt
COPY runner.py ./

RUN chown root:callsite /home/callsite/flag.txt
RUN chmod 440 /home/callsite/flag.txt
RUN chmod 750 /home/callsite/runner.py

EXPOSE 8000
CMD ["python3", "runner.py"]
