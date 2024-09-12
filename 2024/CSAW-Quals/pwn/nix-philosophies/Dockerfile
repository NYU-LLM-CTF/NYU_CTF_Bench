FROM ubuntu:22.04

RUN apt-get update

RUN apt-get install -y software-properties-common && add-apt-repository ppa:ubuntu-toolchain-r/test

RUN apt-get update && apt install -y g++ socat libstdc++6

RUN useradd -m nix

WORKDIR /opt/chal

COPY chal ./
COPY flag.txt ./

RUN chown nix:nix chal && chmod 4755 chal
RUN chown root:root flag.txt && chmod 444 flag.txt

EXPOSE 1000

USER nix
CMD ["socat", "-T300", "TCP-LISTEN:1000,reuseaddr,fork", "EXEC:/opt/chal/chal,pty,echo=0"]
