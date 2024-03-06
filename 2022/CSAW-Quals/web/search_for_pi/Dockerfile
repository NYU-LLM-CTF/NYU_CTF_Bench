FROM node:alpine

COPY ./src /chal
WORKDIR /chal

RUN npm install

USER nobody

EXPOSE 3000
CMD node index.js