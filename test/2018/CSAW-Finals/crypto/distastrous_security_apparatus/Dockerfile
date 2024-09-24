FROM debian:stretch

RUN sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list
RUN sed -i s/security.debian.org/archive.debian.org/g /etc/apt/sources.list
RUN sed -i /stretch-updates/d /etc/apt/sources.list
RUN apt-get -qq update && apt-get install -y python3 python3-pip python3-venv libffi-dev
RUN python3 -m venv /ctf/venv
RUN /ctf/venv/bin/pip install wheel
RUN /ctf/venv/bin/pip install cryptography flask
COPY main.py /ctf/main.py
COPY ctf.key /ctf/ctf.key
ENV CSAW_FLAG=NowyourereadytocrackthePS3YeahSonydidthiswithECDSA
WORKDIR /ctf
EXPOSE 5000
CMD ["/ctf/venv/bin/python", "main.py"]
