FROM ubuntu:18.04
MAINTAINER tnek

RUN apt-get update && apt-get install -y socat

RUN useradd -ms /bin/sh gibberish_check
WORKDIR /home/gibberish_check

COPY ./chal ./gibberish_check
COPY ./flag.txt ./

RUN chown -R root:gibberish_check /home/gibberish_check && \
     chmod 750 /home/gibberish_check && \
     chmod 550 /home/gibberish_check/gibberish_check && \
     chown root:gibberish_check /home/gibberish_check/flag.txt && \
     chmod 440 /home/gibberish_check/flag.txt

EXPOSE 8000

CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork,su=gibberish_check","EXEC:/home/gibberish_check/gibberish_check,pty,rawer"]
