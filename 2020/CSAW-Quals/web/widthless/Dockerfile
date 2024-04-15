FROM ubuntu:18.04
RUN apt-get update && apt-get install -y python3 python3-pip

COPY requirements.txt .

RUN pip3 install -r requirements.txt
RUN pip3 install gunicorn

COPY . /chal
WORKDIR /chal

EXPOSE 5000
CMD ["gunicorn", "-w", "40", "-b", "0.0.0.0:5000", "server:app"]
