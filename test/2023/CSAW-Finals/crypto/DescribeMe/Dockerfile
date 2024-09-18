FROM python:3.6.9-slim

RUN apt-get update && apt-get install --no-install-recommends -y socat \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd ctf \
    && useradd -r -g ctf ctf

WORKDIR /home/ctf

COPY chall.py flag.txt ./
RUN chmod 500 ./chall.py && chown ctf:root . -R && chmod 444 ./flag.txt

EXPOSE 21200
USER ctf
CMD socat -T5 TCP-L:21200,fork,reuseaddr EXEC:"python3 chall.py",pty,stderr,setsid,sane,raw,echo=0
