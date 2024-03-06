# sudo docker build . –t ptmic
# sudo docker run -p 5000:5000 -it ptmic
# nc localhost 5000

FROM python:3.8

RUN apt update \
  && apt install -y socat gcc \
  && pip3 install pycryptodome sympy \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m chal

WORKDIR /opt/chal

COPY flag.txt .
COPY password.txt .
COPY server.py .

RUN chmod -R -w .

USER chal
CMD ["socat", "-T300", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:/usr/local/bin/python3 /opt/chal/server.py,pty,echo=0"]
