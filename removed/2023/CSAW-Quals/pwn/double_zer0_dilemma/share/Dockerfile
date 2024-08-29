FROM ubuntu:20.04 as ctf

ENV HOME /root
RUN id

RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get install -y g++-multilib
RUN apt-get install -y socat
RUN apt-get install -y gdb

RUN groupadd --gid 995 ctf
RUN useradd -m --uid 995 --gid 995 ctf

COPY ./chal /home/ctf/

WORKDIR /home/ctf/

RUN rm -r src
RUN chown -R root:root .
RUN chmod 755 double_zer0_dilemma
RUN chmod 755 flag

EXPOSE 9999:9999

USER ctf

CMD ["socat", "-T60", "TCP-LISTEN:9999,reuseaddr,fork", "EXEC:./double_zer0_dilemma"]
