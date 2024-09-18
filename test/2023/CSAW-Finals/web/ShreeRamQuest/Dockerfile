# Use an official Node.js runtime as the base image
FROM node:18

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy your Node.js application code to the container
COPY . .

# Expose port 5000 for the Node.js application
EXPOSE 4999

# PROD
ENV NODE_ENV production

# Run your Node.js application
CMD [ "node", "app.js" ]
