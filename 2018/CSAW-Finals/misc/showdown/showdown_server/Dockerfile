FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y socat curl
RUN curl -fsSL https://get.docker.com | sh

COPY ./serve.sh /serve.sh
COPY ./showdown /showdown
COPY ./flag /flag
RUN chmod +x /serve.sh /showdown

ARG DOND_SHIM_VERSION="0.6.0"
ARG DOND_SHIM_PATH="/usr/local/bin/dond"
ADD "https://github.com/felipecrs/docker-on-docker-shim/raw/v${DOND_SHIM_VERSION}/dond" "${DOND_SHIM_PATH}"
RUN chmod +x "${DOND_SHIM_PATH}"

CMD ["/serve.sh"]
