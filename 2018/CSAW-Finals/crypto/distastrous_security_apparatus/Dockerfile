FROM debian:stretch

RUN apt-get -qq update && apt-get install -y python3 python3-pip python3-venv
RUN python3 -m venv /ctf/venv
RUN /ctf/venv/bin/pip install wheel
RUN /ctf/venv/bin/pip install cryptography flask
COPY main.py /ctf/main.py
COPY ctf.key /ctf/ctf.key
ENV CSAW_FLAG=NowyourereadytocrackthePS3YeahSonydidthiswithECDSA
WORKDIR /ctf
EXPOSE 5000
CMD ["/ctf/venv/bin/python", "main.py"]
