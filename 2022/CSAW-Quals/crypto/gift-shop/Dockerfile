# sudo docker build -t giftshop .
# sudo docker run -p 6000:6000 -it giftshop
# nc localhost 6000

FROM debian

RUN apt-get update && apt-get install -y vim python3 python3-pip
RUN apt-get install -y socat && rm -rf /var/lib/apt/lists/*

RUN useradd -M chal

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /opt/chal

COPY server.py .
COPY flag.txt .
COPY key .

RUN chmod 444 flag.txt server.py && chmod -w .

EXPOSE 6000
CMD ["socat", "-T60", "TCP-LISTEN:6000,reuseaddr,fork", "EXEC:/usr/bin/python3 /opt/chal/server.py,pty,echo=0"]