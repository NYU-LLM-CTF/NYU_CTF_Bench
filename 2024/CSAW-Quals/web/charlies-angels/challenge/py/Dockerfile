FROM python:3.11-slim-bullseye

RUN apt update && \
    apt install -y --no-install-recommends python3-dev && \
    rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt /app/requirements.txt
RUN pip3 install -r /app/requirements.txt

COPY app.py /app/app.py
COPY flag /flag
WORKDIR /app
RUN mkdir backups
ENV FLASK_RUN_PORT=1338

RUN chmod -R 1777 /app/backups
RUN chmod -R 1777 /tmp

RUN useradd ctf
USER ctf

#CMD ["flask", "run", "--port", "1338", "--host", "0.0.0.0"]

CMD ["gunicorn"  , "-b", "0.0.0.0:1338", "app:app"]
