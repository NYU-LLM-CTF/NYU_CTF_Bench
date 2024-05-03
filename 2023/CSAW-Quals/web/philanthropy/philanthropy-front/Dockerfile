FROM node:14-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the app source code
COPY . .

# Install the app dependencies
RUN npm install -g npm@8.19.4 && \
    npm install --before 2023-08-15 --legacy-peer-deps

# Build app
RUN npm run build

# Delete map files
RUN find /app -name "*.map" -type f -delete

# Expose port
EXPOSE 4173


CMD ["npm", "run", "serve", "--", "--host"]
