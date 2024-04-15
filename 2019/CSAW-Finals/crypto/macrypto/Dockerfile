FROM ubuntu:18.04
RUN apt-get update && apt-get upgrade -y && apt-get install -y socat

#user
RUN useradd -ms /bin/sh macrypto
RUN chown -R root:macrypto /home/macrypto

WORKDIR /home/macrypto

COPY macrypto ./
COPY flag.txt ./flag.txt

RUN chmod 440 flag.txt && chmod 550 macrypto && chown -R root:macrypto /home/macrypto

EXPOSE 4512
CMD ["socat", "-T6000", "TCP-LISTEN:4512,reuseaddr,fork,su=macrypto","EXEC:/home/macrypto/macrypto"]
