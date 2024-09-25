FROM ruby:latest 
MAINTAINER Oskar
LABEL Description="CSAW 2013-Q: Life" VERSION='1.0'
# Files
RUN mkdir /usr/src/app 
ADD life.rb /usr/src/app/life.rb
ADD key /usr/src/app/key
WORKDIR /usr/src/app/ 
# Execute
EXPOSE 45678
CMD ruby /usr/src/app/life.rb