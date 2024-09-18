FROM python:3.11-alpine

#Install packages
RUN apk add --update --no-cache python3-dev postgresql gcc libpq-dev

# Upgrade pip
RUN python -m pip install --upgrade pip

RUN python -m pip install psycopg2-binary

#Install dependencies
COPY requirements.txt /requirements.txt
RUN python -m pip install -r requirements.txt

# Add user
RUN adduser -D -u 1000 -g 1000 -s /bin/sh www

# Setup app
RUN mkdir -p /app

# Switching working environment
WORKDIR /app

# Add Application
COPY server .
RUN chown -R www:www .
RUN chmod +x run.sh

# Expose port the server
ARG SERVER_PORT
EXPOSE ${SERVER_PORT}

ARG DB_HOST
ARG DB_USERNAME
ARG DB_PASSWORD
ARG DB_PORT

CMD ["/bin/sh","/app/run.sh"]
