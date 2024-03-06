FROM ubuntu:22.04 as ctf

RUN apt-get update && \
    apt-get install -y node-ejs npm python3-pip

# Set the working directory
WORKDIR /CatTheFlag
COPY . /CatTheFlag
RUN npm i nodemon
RUN pip install pandas numpy tensorflow pickle-mixin 

# User credentials
# USER ctf 

# Exposing the port of the container
EXPOSE 3000

# Set the default command
CMD ["/bin/bash", "./start.sh"]

