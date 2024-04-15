FROM python:3.7

RUN mkdir /opt/app
WORKDIR /opt/app

RUN pip3 install gunicorn

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY . .

CMD "./run.sh"
