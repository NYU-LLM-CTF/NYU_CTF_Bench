FROM python:3.8-slim-buster

RUN useradd -r ctf

WORKDIR /app

COPY requirements.txt ./
RUN pip3 install -r requirements.txt

COPY ./ ./

RUN chown -R ctf /app

USER ctf

ENV KINGSDAY="03_07_1341_BC"
ENV FLASK_APP="app.py"

EXPOSE 8050

CMD ["gunicorn", "-b", "0.0.0.0:8050", "-w 1", "app:app"]
