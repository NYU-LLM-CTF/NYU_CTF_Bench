FROM ubuntu:16.04

# Install Node.js
RUN apt-get update && apt-get install -y nodejs python

# Define working directory.
WORKDIR /data

COPY . /data

RUN chmod +x serve.sh
EXPOSE 9999
ENTRYPOINT ["./serve.sh"]