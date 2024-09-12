FROM python:3.12-slim-bookworm

RUN apt-get update && apt-get install -y socat gcc make

RUN useradd -ms /bin/sh ctf
WORKDIR /home/ctf

COPY . .

RUN python3 -m pip install --no-cache-dir  -r requirements.txt

RUN chown -R root:ctf /home/ctf && \
     chmod 750 /home/ctf && \
     chmod 550 /home/ctf/*

ENV AES_KEY=py0GVxEwJg0Uq5zV
ENV AES_IV=OgB2UWlmfkkRhLgt

EXPOSE 9996


CMD ["socat", "-T60", "TCP-LISTEN:9996,reuseaddr,fork,su=ctf", "EXEC:/home/ctf/run.sh"]

