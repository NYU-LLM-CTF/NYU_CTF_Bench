# Using alpine to keep image size down, it omits testing and other modules
FROM node:14-alpine

# Create app directory
WORKDIR /usr/src/app

# Install supervisor and add www user
RUN apk add --update --no-cache supervisor \
    && adduser -DH www


# Install app dependencies
# Copy over package.json and package-lock.json
COPY package*.json ./   
# If run for production: RUN npm ci --only=production
RUN npm install

# Bundle app source
COPY . .

# Modify file permissions to read-only
RUN chmod -w -R .

# Start the app
CMD [ "npm", "start"]
