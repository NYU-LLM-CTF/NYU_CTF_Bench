FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
    apt-get install -y \
        iptables iproute2 net-tools \
        software-properties-common \
        apt-transport-https ca-certificates \
        curl gnupg lsb-release jq

# Install docker cli
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y docker-ce-cli

COPY run.sh /run.sh
CMD [ "bash", "/run.sh" ]
