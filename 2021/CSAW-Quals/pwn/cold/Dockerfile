FROM archlinux

RUN pacman -Sy --noconfirm socat

COPY libc.so.6 libm.so.6 libstdc++.so.6 libgcc_s.so.1 /usr/lib/

RUN chmod 755 \
  /usr/lib//libc.so.6 \
  /usr/lib/libm.so.6 \
  /usr/lib/libstdc++.so.6 \
  /usr/lib/libgcc_s.so.1

WORKDIR /chal
COPY cold .
COPY flag.txt .

RUN chmod -w -R /chal

USER nobody
CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork","EXEC:./cold"]
