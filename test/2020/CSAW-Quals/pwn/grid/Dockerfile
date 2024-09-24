FROM ubuntu:18.04

RUN apt-get update && apt-get install -y socat libstdc++6

RUN useradd -ms /bin/sh grid

WORKDIR /home/grid

COPY grid .
COPY flag.txt .

RUN chown -R root:grid /home/grid && \
    chown root:grid /home/grid/flag.txt && \
    chmod 440 /home/grid/flag.txt && \
    chmod 555 grid

EXPOSE 8000
USER grid
CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork","EXEC:/home/grid/grid"]
