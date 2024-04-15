FROM ubuntu:22.04 as ctf

RUN apt-get update -y && apt-get install -y \
    python3-pip


COPY Deploy/requirements.txt /impromptu/requirements.txt

# Set the working directory
WORKDIR /impromptu

RUN pip3 install -r requirements.txt

COPY Deploy/ /impromptu

# Set the default command
CMD ["python3", "app.py"]

# Exposing the port of the container
EXPOSE 5000

