FROM ubuntu:18.04

RUN apt-get -y update && apt-get -y install libpcre3-dev wget make build-essential zlib1g-dev  npm

# INSTALL VULNERABLE VERSION OF NGINX 
RUN wget "https://nginx.org/download/nginx-1.17.6.tar.gz" && \
    tar zxf "nginx-1.17.6.tar.gz" && \ 
    cd "nginx-1.17.6" && \ 
    ./configure && \
    make && \
    make install  


# CUSTOM NGINX FILES 
COPY custom_nginx_conf /usr/local/nginx/conf
EXPOSE 3009
RUN /usr/local/nginx/sbin/nginx &


# INSTALL NODE APP 
RUN mkdir -p /home/node/dino_smuggling/node_modules
COPY dino_smuggling/ /home/node/dino_smuggling/

WORKDIR /home/node/dino_smuggling


RUN npm install

ENTRYPOINT ["sh", "-c", "/usr/local/nginx/sbin/nginx && node app.js"]


