FROM debian

RUN apt update && apt install -y --no-install-recommends python3 && rm -rf /var/apt/lists/*

WORKDIR /chal
COPY maze .
COPY server.py .

RUN chmod -w -R /chal

USER nobody
CMD ["python3", "/chal/server.py"]

