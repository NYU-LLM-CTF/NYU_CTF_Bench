# syntax=docker/dockerfile:1

FROM python:3.9.10

WORKDIR /python-docker

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY aemm-config.json /nonexistent/
COPY ec2-metadata-mock-linux-amd64 /usr/bin/

RUN chmod +x /usr/bin/ec2-metadata-mock-linux-amd64

COPY . .

RUN chmod +x serve.sh

EXPOSE 5000 1338

USER nobody

ENTRYPOINT ["/python-docker/serve.sh"]
