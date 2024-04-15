FROM ubuntu:18.04

RUN apt-get -y update && apt-get -y upgrade

# You need gpg keys for this
RUN apt-get install -y curl gnupg2

# YOu need node > 8
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get install -y nodejs

RUN apt-get clean

ARG user=bebe

RUN useradd -ms /bin/sh ${user}
WORKDIR /home/${user}/serv

COPY ./serv/package.json /home/${user}/serv
RUN npm install

COPY ./serv /home/${user}/serv
RUN chown -R ${user}:${user} /home/${user} && \
  chmod 544 -R /home/${user}/serv
# Setting ports for chalbot and server
EXPOSE 8000
ENV PORT 8000

USER ${user}

CMD ["npm", "start"]