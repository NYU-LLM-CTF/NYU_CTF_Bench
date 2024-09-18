FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y curl

USER root

# Install the backend
WORKDIR /usr/src/app
ENV NODE_VERSION=18.16.1
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="${NVM_DIR}/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version
# Copy package.json and package-lock.json to the working directory
COPY ./server_files/* ./
# Install the server app dependencies
RUN npm install
COPY ./flag.txt /
# Flag should only be readable by root
RUN chmod 400 /flag.txt
# Server source should be readable by all
RUN chmod -R a+rX /usr/src/app

# Frontend
RUN useradd -ms /bin/sh user
RUN mkdir /home/user/frontend
COPY ./files /home/user/frontend
# Make all files belong to user
RUN chown -R user:user /home/user/frontend

RUN mkdir /ftp
# ftp_base is just used to initially give the note.txt file
RUN useradd -d /ftp/ftp_base -ms /bin/sh ftp_base
RUN echo "ftp_base:r5TgKiP18L1VwuX0K0JZEX7V4j31wh" | chpasswd
# ftp_base home dir cannot be writable by anyone
RUN chmod 555 /ftp/ftp_base
COPY --chown=ftp_base:ftp_base ./note.txt /ftp/ftp_base/note.txt

# ftp_dev gets to see the server app source code
RUN useradd -d /usr/src/app -ms /bin/sh ftp_dev
RUN echo "ftp_dev:vOc!&6k(G;uNSqjQBt=M" | chpasswd

# Install frontend
USER user
# node config
ENV NODE_VERSION=18.16.1
ENV NVM_DIR=/home/user/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="${NVM_DIR}/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version
#RUN apt-get install -y npm

WORKDIR /home/user/frontend
RUN npm i
RUN npm run build

# Install vsftpd
USER root
RUN apt-get install -y vsftpd supervisor
RUN mkdir -p /var/run/vsftpd/empty
COPY ./vsftpd.conf /etc/vsftpd.conf
COPY ./supervisord.conf /supervisord.conf
CMD ["supervisord", "-c", "/supervisord.conf"]
