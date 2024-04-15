FROM debian:stable-slim as builder
RUN apt-get -y update && apt-get -y install build-essential python3 python3-pip clang libssl-dev && python3 -m pip install pycryptodome
WORKDIR /app
COPY aes_128.txt Makefile main.c common.c common.h circ.py /app/
RUN sed -i 's/python/python3/' Makefile && make

FROM debian:stable-slim
RUN apt-get -y update && apt-get -y install xinetd
RUN useradd ctf
WORKDIR /app
COPY --from=builder /app/losing_my_marbles /app/
COPY wrapper.sh flag.txt key /app/
COPY marbles.xinetd /etc/xinetd.d/marbles
RUN chown -R ctf /app

CMD xinetd -dontfork
EXPOSE 5000