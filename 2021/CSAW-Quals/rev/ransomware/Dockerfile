FROM alpine:latest

RUN apk add --update python3

COPY 5692481aecd40429eecf588d28ce6a31 /opt/chal/5692481aecd40429eecf588d28ce6a31
COPY index.html /opt/chal/index.html

RUN chmod -w -R /opt/chal/
WORKDIR /opt/chal

USER nobody
CMD ["python3", "-m", "http.server", "9000"]
