FROM python:3.8
MAINTAINER vishnu

RUN apt update
RUN apt install -y socat && rm -rf /var/lib/apt/lists/*

RUN useradd -m chal

RUN pip3 install web3

WORKDIR /opt/chal

COPY blockchainChallenge.sol .
COPY give_flag.py .

RUN chmod 555 blockchainChallenge.sol
RUN chmod +x give_flag.py
EXPOSE 5000

USER chal
CMD ["socat", "-T600", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:/usr/local/bin/python3 ./give_flag.py"]