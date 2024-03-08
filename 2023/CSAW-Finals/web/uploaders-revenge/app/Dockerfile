# syntax=docker/dockerfile:1
FROM python:3.7-alpine
#RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
WORKDIR /code
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
#ENV FLASK_ENV=development
EXPOSE 5000
COPY app.py .
CMD ["flask", "run"]
