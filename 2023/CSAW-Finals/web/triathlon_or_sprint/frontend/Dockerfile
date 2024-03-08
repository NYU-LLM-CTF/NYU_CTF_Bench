FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y curl

# node config
ENV NODE_VERSION=18.16.1
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

#RUN apt-get install -y npm

RUN useradd -ms /bin/sh user
RUN mkdir /home/user/frontend
WORKDIR /home/user/frontend

COPY ./files .
RUN npm i
RUN npm run build
EXPOSE 8000

CMD ["npm","run","preview","--","--host"]
