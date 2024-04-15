FROM python:3.6

EXPOSE 5000

RUN mkdir /app
WORKDIR /app


COPY pip-freeze.txt /app/pip-freeze.txt
RUN pip install --upgrade pip
RUN pip install -r pip-freeze.txt

COPY . /app

CMD python main.py