docker build --tag python-docker .
docker run -d -p 4999:4999 python-docker
