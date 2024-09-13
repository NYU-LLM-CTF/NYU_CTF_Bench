FROM node

WORKDIR /usr/src/app
RUN mkdir -p sessions

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 1337

RUN chmod -R 1777 /usr/src/app/sessions

RUN useradd ctf
USER ctf

CMD [ "node", "index.js"]
