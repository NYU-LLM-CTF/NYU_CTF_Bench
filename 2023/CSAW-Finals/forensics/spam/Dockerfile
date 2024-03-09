FROM node:18.17.0-alpine

WORKDIR /usr/src/app

COPY ./my-website/package*.json ./

RUN npm install

COPY ./my-website ./

RUN npm run build
    
EXPOSE 3000

CMD ["npm", "run", "serve"]