FROM ubuntu:16.04
LABEL Description="CSAW 2017 48-BIT BOMB" VERSION='1.0'

RUN apt-get clean
RUN apt-get update && apt-get upgrade -y
RUN apt-get install socat build-essential lib32z1 -y

WORKDIR /app
COPY ./bomblab /app/
copy ./flag.txt /app/
RUN chmod +r /app/flag.txt
RUN chmod 755 /app/bomblab

EXPOSE 4848
ENTRYPOINT ["socat", "TCP-LISTEN:4848,reuseaddr,fork","EXEC:/app/bomblab"]
