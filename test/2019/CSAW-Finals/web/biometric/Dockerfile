FROM python:3.6-alpine
RUN apk add g++

EXPOSE 5001

RUN mkdir /app
WORKDIR /app


COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

COPY . /app


ENV flag flag{eye_see_you}
CMD python main.py
