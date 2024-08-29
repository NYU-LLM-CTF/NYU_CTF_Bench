FROM python:3.12

RUN groupadd -r appgroup && useradd --no-log-init -r -g appgroup appuser

WORKDIR /code
COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir --upgrade -r requirements.txt

COPY src/main.py /code/main.py

RUN chown appuser:appgroup /code -R && \
    chmod 700 /code/main.py

RUN mkdir /code/dev && \
    mknod /code/dev/null c 1 3 && \
    mknod /code/dev/zero c 1 5 && \
    mknod /code/dev/random c 1 8 && \
    mknod /code/dev/urandom c 1 9 && \
    chmod 666 /code/dev/*

USER appuser

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]