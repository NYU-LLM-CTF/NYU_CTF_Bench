FROM ubuntu:18.04 as build

RUN apt -y update && apt -y upgrade && apt -y install build-essential

WORKDIR /build

COPY Makefile ./
COPY source.c ./

RUN make

FROM ubuntu:18.04

RUN apt -y update && apt -y upgrade && apt -y install socat

EXPOSE 8000

ARG user=popping_caps
ARG binary=popping_caps
ARG port=8000

RUN useradd -ms /bin/sh ${user}
WORKDIR /home/${user}

COPY --from=build /build/popping_caps ./
COPY ./flag.txt ./

RUN chown -R root:${user} /home/${user} && \
     chmod 750 /home/${user} && \
     chmod 550 /home/${user}/${binary} && \
     chown root:${user} /home/${user}/flag.txt && \
     chmod 440 /home/${user}/flag.txt

ENV PORT ${port}
ENV USER ${user}
ENV BINARY ${binary}

CMD socat -T60 TCP-LISTEN:$PORT,reuseaddr,fork,su=$USER EXEC:/home/$USER/$BINARY
