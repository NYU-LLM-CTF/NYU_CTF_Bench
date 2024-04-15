FROM ubuntu:18.04
MAINTAINER __mgb__
RUN apt update && apt install -y python python-dev python-pip

RUN pip install music21==4.1.0
RUN pip install gunicorn
RUN pip install flask

RUN mkdir /chal
WORKDIR chal

ADD static/ static/
ADD templates/ templates
ADD secrets.py secrets.py
ADD music.py music.py
ADD runner.py app.py
ADD pshares pshares
RUN mkdir musicals
RUN mkdir tmp

RUN python -c "import music21; music21.environment.UserSettings()['warnings'] = 0"
EXPOSE 5000

CMD ["gunicorn", "-w", "40", "-b", "0.0.0.0:5000", "app:app"]
