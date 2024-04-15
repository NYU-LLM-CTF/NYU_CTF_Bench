FROM ubuntu:18.04

RUN apt-get -y update && apt-get -y upgrade && apt-get -y install socat

ARG user=tvm
ARG binary=tvm
ARG port=8000

RUN useradd -ms /bin/sh ${user}
WORKDIR /home/${user}

COPY ./server/${binary} ./
COPY ./server/flag ./

RUN chown -R root:${user} /home/${user} && \
    chmod 750 /home/${user} && \
    chmod 550 /home/${user}/${binary} && \
    chown root:${user} /home/${user}/flag && \
    chmod 440 /home/${user}/flag

ENV PORT ${port}
ENV USER ${user}
ENV BINARY ${binary}

EXPOSE 8000
CMD socat -T60 TCP-LISTEN:$PORT,reuseaddr,fork,su=$USER EXEC:/home/$USER/$BINARY
