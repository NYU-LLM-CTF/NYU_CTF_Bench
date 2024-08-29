# Use the official MySQL 8.0 image as the base image
FROM mysql:8.0

# Copy the custom configuration file to the container
# COPY my.cnf /etc/mysql/conf.d/my.cnf

# Copy any SQL scripts to initialize the database
COPY ./db/init.sql /docker-entrypoint-initdb.d/

# Expose the default MySQL port
EXPOSE 3306

# Start the MySQL server when the container launches
CMD ["mysqld"]