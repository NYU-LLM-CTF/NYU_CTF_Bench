# sudo docker build -t ecc .
# sudo docker run -p 6000:6000 -it ecc
# nc localhost 6000

FROM sagemath/sagemath:9.1
ENV DEBIAN_FRONTEND=noninteractive
RUN sudo apt-get update \
    && sudo apt-get install -y socat --fix-missing \
    && sudo rm -r /var/lib/apt/lists/*

COPY src/chall.sage /opt/chal/chall.sage
# DO NOT EXPOSE THE HELPERS FILE
COPY src/helpers.sage /opt/chal/helpers.sage
COPY src/mv_ecc.sage /opt/chal/mv_ecc.sage
COPY src/flag.txt /opt/chal/flag.txt
COPY src/secret_key64.txt /opt/chal/secret_key64.txt

WORKDIR /opt/chal

EXPOSE 6000
ENTRYPOINT sudo socat -dd TCP4-LISTEN:6000,fork,reuseaddr EXEC:"sage chall.sage"

