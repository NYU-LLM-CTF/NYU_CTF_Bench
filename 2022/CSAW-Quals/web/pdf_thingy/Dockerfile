FROM node:18-bullseye-slim

# RUN apt-get update && apt-get -y install libdrm2 libcups2 libatk-bridge2.0-0 libnspr4 libnss3 libnss3-tools libglib2.0-0 libatk1.0-0
RUN apt-get update && apt-get install -y git curl libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libstdc++6 ca-certificates fonts-liberation libnss3 libgbm-dev


COPY ./flag.txt /flag.txt

RUN chown www-data:www-data /flag.txt
RUN chmod 400 /flag.txt

COPY ./src /chal
WORKDIR /chal
RUN npm i patch-package
RUN npm install
# Need to run chrome in sandbox mode
RUN sed -i 's/launch_options: {}/launch_options: {args: ["--no-sandbox"]}/' node_modules/md-to-pdf/dist/lib/config.js
RUN npx patch-package 'md-to-pdf'

EXPOSE 3000

USER www-data
CMD node index.js

