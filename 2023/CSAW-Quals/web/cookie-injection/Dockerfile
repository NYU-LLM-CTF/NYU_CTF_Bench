FROM mysql:8.0-debian

RUN apt-get update \
&& apt-get install python3 python3-pip -y \
&& rm -rf /var/lib/apt/lists/* \
&& groupadd ctf \
&& useradd -r -g ctf ctf

RUN mkdir /app
RUN chmod 755 /app
RUN chown root:root /app

ENV MYSQL_USER usrrr
ENV MYSQL_PASSWORD password
ENV MYSQL_DATABASE email_sqli_ctf
ENV MYSQL_ROOT_PASSWORD password

WORKDIR /app

COPY SQL/ ./SQL/
COPY templates/ ./templates/
COPY app.py init.py login.py start.sh ./

RUN chmod 755 . -R && chown root:root . -R

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

EXPOSE 5800

#USER ctf
#CMD ["python3", "/app/init.py"]

COPY SQL/email_sqli_ctf.sql /docker-entrypoint-initdb.d/
COPY start.sh /docker-entrypoint-initdb.d/


