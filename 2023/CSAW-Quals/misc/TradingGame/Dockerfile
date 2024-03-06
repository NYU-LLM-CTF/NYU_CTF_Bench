FROM python:3.11-slim

RUN apt-get update \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd ctf \
    && useradd -r -g ctf ctf

USER root

RUN mkdir /app
RUN chmod 755 /app
RUN chown root:root /app

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY src/app.py src/start.sh src/process.py flag.txt ./
RUN chmod 755 ./start.sh && chmod 755 ./process.py && chmod 755 ./app.py && chown root:root . -R && chmod 444 ./flag.txt

EXPOSE 4657

USER ctf
CMD /app/start.sh
