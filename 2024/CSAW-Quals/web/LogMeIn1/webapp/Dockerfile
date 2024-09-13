FROM python:3.12-slim-bookworm

RUN apt-get update
RUN apt-get install python3-dev postgresql gcc libpq-dev -y

RUN useradd -ms /bin/sh ctf
WORKDIR /home/ctf

COPY ./ /home/ctf/
RUN python3 -m pip install --no-cache-dir  -r requirements.txt

RUN chown -R root:ctf /home/ctf && \
     chmod 750 /home/ctf && \
     chmod 550 /home/ctf/* && \
     chown root:ctf /home/ctf/flag.txt && \
     chmod 440 /home/ctf/flag.txt

RUN chmod 755 /home/ctf/static
RUN chmod 755 /home/ctf/templates

USER ctf

# Expose port the server
ARG SERVER_PORT
EXPOSE ${SERVER_PORT}

ARG DB_HOST
ARG DB_USERNAME
ARG DB_PASSWORD
ARG DB_PORT

ARG FLASK_SECRET

ARG ENCRYPT_KEY

#CMD gunicorn --log-level debug --workers 8 -b 0.0.0.0:$SERVER_PORT app:app
CMD sh run.sh
