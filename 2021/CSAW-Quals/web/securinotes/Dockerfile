FROM debian

# Install packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl procps && \
    rm -rf /var/lib/apt/lists/*

# Copy application sources
WORKDIR /app

COPY ./.meteor ./.meteor
COPY ./client ./client
COPY ./imports ./imports
COPY ./public ./public
COPY ./server ./server

RUN true
COPY ./package.json .
COPY ./package-lock.json .

# Install MeteorJS
RUN curl "https://install.meteor.com/?release=1.8.1" | sh

# Install packages that meteor does not manage itself
RUN meteor npm install

CMD ["/usr/local/bin/meteor", "run", "--allow-superuser", "--port", "0.0.0.0:5000"]
