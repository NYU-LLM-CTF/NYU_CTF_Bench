# Use an official Node.js runtime as a base image
FROM node:18

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY ./files/* ./

# Install the app dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY ./flag.txt /

# Expose a port that the app will run on
EXPOSE 3000

USER node

# Define the command to run the application
CMD ["npm", "start"]
