FROM ubuntu:18.04

MAINTAINER tnek

ENV FLAGON_SECRET_KEY superdupersecretflagonkey

RUN apt-get update
RUN apt-get install -y firefox python3 python3-pip
COPY geckodriver /usr/local/bin

COPY requirements.txt .
RUN pip3 install -U pip
RUN pip3 install -r requirements.txt
RUN pip3 install gunicorn

#ARG user=flagon

#RUN useradd -ms /bin/sh ${user}
#WORKDIR /home/${user}

COPY chal ./
COPY ./flag.txt ./

#RUN mkdir /home/${user}/.mozilla 
#RUN chmod 750 /home/${user} && \
#     chown root:${user} /home/${user}/flag.txt && \
#     chmod 440 /home/${user}/flag.txt && \
#     chmod 777 /home/${user}/neko.db && \
#     chown ${user}:${user} /home/${user}/neko.db && \
#     chmod 750 /home/${user}/*.py && \
#     chown -R root:${user} /home/${user}/*.py && \
#     chown -R root:${user} /home/${user}/static && \
#     chown -R root:${user} /home/${user}/templates && \
#     chown -R root:${user} /home/${user}/flagon && \
#     chmod -R 750 /home/${user}/static && \
#     chmod -R 750 /home/${user}/templates && \
#     chmod -R 750 /home/${user}/flagon && \
#     chown ${user}:${user} /home/${user}/.mozilla
#
#

EXPOSE 5000 

#CMD ["sudo", "-E", "-u", ${user}, "python3", "app.py"]

#CMD ["su", "flagon", "-m", "-c", "python3 app.py"]

CMD ["python3", "app.py"]

# bug doesn't seem to work under gunicorn
#CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
