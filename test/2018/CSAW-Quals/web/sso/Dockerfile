FROM node:10-alpine

WORKDIR /app

RUN yarn global add node-gyp
COPY package.json yarn.lock ./
RUN yarn install

COPY . ./

ENV FLAG=flag{JsonWebTokensaretheeasieststorage-lessdataoptiononthemarket!theyrelyonsupersecureblockchainlevelencryptionfortheirmethods}
ENV JWT_SECRET=ufoundme!
ENV SECRET_KEY=icantbelieveyoufoundmetoo(wrongwaytho)

CMD ["npm", "start"]