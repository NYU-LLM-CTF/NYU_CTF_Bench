FROM vulhub/ghostscript:9.23-python

RUN useradd -ms /bin/sh picgram

RUN apt-get update && apt-get install -y curl sqlite3
RUN set -ex \
    && pip install -U pip \
    && pip install "flask" "Pillow==5.3.0" "gunicorn"

WORKDIR /home/picgram

COPY app.py ./app.py
COPY templates ./templates

COPY flag.db /home/picgram/flag.db

RUN chown -R root:picgram /home/picgram && \
    chown 750 /home/picgram

EXPOSE 5000
USER picgram
CMD ["gunicorn", "-w", "3", "-b", "0.0.0.0:5000", "app:app"]
