FROM archlinux:latest

RUN pacman -Sy
RUN pacman -S python --noconfirm && pacman -S vim --noconfirm \
    && pacman -S gcc --noconfirm && pacman -S lld --noconfirm \
    && pacman -S socat --noconfirm

RUN mkdir /opt/chal
WORKDIR /opt/chal

COPY word_games.c .
RUN gcc word_games.c -o word_games -fstack-protector-all -s
RUN rm word_games.c
COPY flag.txt .

RUN rm -rf /var/lib/pacman/*

RUN chmod 444 flag.txt && chmod 555 word_games

USER nobody
CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork","EXEC:./word_games"]