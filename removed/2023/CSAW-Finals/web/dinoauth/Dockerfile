FROM node:latest

# Create a working directory for the app
WORKDIR /app

# Add the ctf user
RUN useradd ctf

# Copy the app files into the Docker container
COPY --chown=ctf ./src /app

# Install the Node dependencies
RUN npm install

# change this to hostname/ip addr
ENV HOST='web-chal.csaw.io'

# Expose the frontend and backend ports
EXPOSE 3001 3002

# Start the Koa server
CMD ["/bin/bash","start.sh"]
