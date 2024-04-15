FROM php:5.6-cli 
MAINTAINER Oskar
LABEL Description="CSAW 2014-F: PPS" VERSION='1.0'
# Update
RUN apt-get update && apt-get -y upgrade && apt-get install -y socat
# Files
ADD deploy /app
WORKDIR /app
# Execute
EXPOSE 5665
CMD socat -T60 TCP-LISTEN:5665,reuseaddr,fork EXEC:/app/pps.php