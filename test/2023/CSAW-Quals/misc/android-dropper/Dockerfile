FROM ubuntu:20.04 as ctf

RUN apt-get update && \
    apt-get install -y python3 python3-pip

RUN pip install flask
RUN pip install gunicorn
RUN useradd -m ctf

WORKDIR /home/ctf

COPY ./server /home/ctf/

RUN chown -R root:ctf /home/ctf && \
    chmod -R 750 /home/ctf && \
    chmod 740 /home/ctf/flag.txt

EXPOSE 3003

#CMD ["/usr/bin/python3","server.py"]
CMD ["/bin/sh","start.sh"]