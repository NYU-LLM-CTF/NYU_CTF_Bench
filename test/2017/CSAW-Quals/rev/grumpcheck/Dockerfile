FROM ubuntu:14.04
RUN sudo apt-get update -y && sudo apt-get install python-pip socat -y
COPY . /app
WORKDIR /app
RUN chmod +x serve.sh
CMD ["./serve.sh"]
