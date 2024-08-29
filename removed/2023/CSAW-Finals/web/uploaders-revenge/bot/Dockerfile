FROM mcr.microsoft.com/playwright:latest

RUN mkdir /app
WORKDIR /app
COPY package*.json /app/
# create user `bot`
#RUN adduser -D -u 1001 bot && \
#    mkdir -p /home/bot && \
#    chown -R bot:bot /home/bot

#USER bot
RUN npm i
RUN npx playwright install firefox

COPY *.js .

ENTRYPOINT ["node", "app.js"]
