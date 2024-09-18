FROM ubuntu:21.04

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt-get update
RUN apt-get install -y \
  apt-utils \ 
  python3

RUN useradd -ms /bin/sh terminal
WORKDIR /home/terminal

COPY ./service.py ./
COPY ./text1.png ./
COPY ./text2.six ./
COPY ./text3.tek ./

RUN chown -R root:terminal /home/terminal && \
  chmod 750 /home/terminal && \
  chmod 550 /home/terminal/service.py && \
  chmod 555 /home/terminal/text1.png && \
  chmod 555 /home/terminal/text2.six && \
  chmod 555 /home/terminal/text3.tek

EXPOSE 3535

CMD ["python3", "/home/terminal/service.py"]

