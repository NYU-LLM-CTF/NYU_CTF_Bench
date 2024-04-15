FROM  ubuntu:18.04

RUN apt-get update -y && apt-get install curl -y && (curl -sL https://deb.nodesource.com/setup_8.x | bash -) && apt-get install -y nodejs && groupadd -g 1000 app && useradd -g app -m -u 1000 app -s /bin/bash
EXPOSE 3000

COPY . /

RUN npm i

USER app

CMD ["bash","run.sh"]
