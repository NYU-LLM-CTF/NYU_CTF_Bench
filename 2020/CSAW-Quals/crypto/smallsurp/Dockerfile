FROM ubuntu:18.04
RUN apt-get update && apt-get install -y python3-pip

RUN useradd -ms /bin/sh smallsurp

WORKDIR /home/smallsurp

RUN pip3 install pycryptodome flask gunicorn

COPY . .
EXPOSE 5000

CMD ["gunicorn", "-w", "10", "-b", "0.0.0.0:5000", "server:app"]
