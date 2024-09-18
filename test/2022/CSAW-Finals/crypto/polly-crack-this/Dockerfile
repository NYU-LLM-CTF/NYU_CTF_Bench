# sudo docker build -t polly .
# sudo docker run -p 6000:6000 -it polly
# nc localhost 6000

FROM sagemath/sagemath:9.1

ENV DEBIAN_FRONTEND=noninteractive
RUN sudo apt-get update \
    && sudo apt-get install -y socat --fix-missing \
    && sudo rm -r /var/lib/apt/lists/*


COPY src/ideal.sage /opt/chal/ideal.sage
COPY src/flag.txt /opt/chal/flag.txt

WORKDIR /opt/chal

EXPOSE 6000
ENTRYPOINT sudo socat -dd TCP4-LISTEN:6000,fork,reuseaddr EXEC:"sage ideal.sage"

