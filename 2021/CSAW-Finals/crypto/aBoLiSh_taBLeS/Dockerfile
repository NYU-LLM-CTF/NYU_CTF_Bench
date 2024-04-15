FROM sagemath/sagemath:latest

USER root
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt -y dist-upgrade && apt -y install xinetd

RUN mkdir /app && chown sage /app
WORKDIR /app

COPY flag.txt /app/flag.txt
COPY chal.sage /app/chal.sage
COPY entry.sh /app/entry.sh
COPY abolish.xinetd /etc/xinetd.d/abolish

RUN chown -R sage /app

ENTRYPOINT ["/usr/sbin/xinetd", "-dontfork"]
EXPOSE 5000
