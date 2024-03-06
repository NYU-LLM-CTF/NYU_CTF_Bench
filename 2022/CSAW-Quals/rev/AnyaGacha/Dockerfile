FROM node:16

WORKDIR /opt/chal

COPY ./src/server .

RUN npm install

RUN npm install express@">=3.0.0 <4.0.0" --save

USER nobody

CMD [ "node", "/opt/chal/index.js"]
