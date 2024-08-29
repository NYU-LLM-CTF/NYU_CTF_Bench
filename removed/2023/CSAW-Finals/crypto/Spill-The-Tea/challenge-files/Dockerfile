FROM node:latest

WORKDIR /app
COPY * ./
COPY ./src ./src
COPY ./public ./public

RUN yarn install

EXPOSE 5173
CMD ["yarn", "dev", "--host"]
