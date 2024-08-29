FROM ubuntu:18.04
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get install -y git procps build-essential gdb python-pip glibc-doc manpages-dev \
    && apt-get install -y gcc-multilib g++-multilib netcat docker-compose \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
RUN pip install pwntools
