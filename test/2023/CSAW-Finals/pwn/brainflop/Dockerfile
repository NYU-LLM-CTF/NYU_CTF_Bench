FROM ubuntu:23.10 as csaw-ctf-2023-brainflop

RUN apt-get update && apt-get install -y socat python3 libsqlite3-dev libc++-dev
RUN useradd -m brainflop

WORKDIR /home/brainflop

COPY ./server.py /home/brainflop/server.py
COPY ./chal/ /home/brainflop/chal/

RUN chown -R brainflop:brainflop /home/brainflop && \
    chmod +x /home/brainflop/chal/challenge

WORKDIR /home/brainflop
USER brainflop

EXPOSE 9999
CMD socat -T5 TCP-L:9999,fork,reuseaddr EXEC:"python3 server.py"
