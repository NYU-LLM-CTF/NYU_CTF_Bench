FROM python:2.7-alpine

RUN pip install flask 

COPY ./src /chal
WORKDIR /chal

RUN chmod -w -R /chal

USER nobody

CMD flask run --host=0.0.0.0 -p 5000




