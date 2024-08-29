FROM ubuntu:18.04

RUN adduser --disabled-password --gecos '' www

RUN apt-get update && apt-get install -y coturn redis python3 python3-pip gunicorn3 supervisor

WORKDIR app
COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY flag.txt /
RUN chmod 444 /flag.txt

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN echo 'min-port=49000' >> /etc/turnserver.conf
RUN echo 'max-port=49100' >> /etc/turnserver.conf

COPY app.py .
COPY static static

EXPOSE 3478
EXPOSE 5000

CMD ["supervisord"]
