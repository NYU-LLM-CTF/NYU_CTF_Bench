FROM ruby:latest
MAINTAINER unknonwn
LABEL Description="CSAW 2015-Q: Meme-shop" VERSION='1.0'

RUN apt-get update && apt-get -y upgrade && apt-get install -y build-essential socat

RUN gem install colorize pry

WORKDIR /root/meme-shop
COPY . .

RUN cd plugin && ruby extconf.rb && make && cd ..

ENV FLAG_PATH=/root/meme-shop/flag

RUN find . -name '*.c' -delete
RUN find . -name '*_debug.rb' -delete

RUN chmod 750 memeshop.rb

# Command to run the challenge using socat or another method
# Replace 'ruby main.rb' with the actual command if different
CMD ["socat", "TCP-LISTEN:8000,fork", "EXEC:ruby memeshop.rb"]