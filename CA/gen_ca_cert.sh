#!/usr/bin/env bash

# Generates the CA cert; the resulting cert should be distributed to
# the clients and trusted.
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 1825 -out ca.crt -subj "/C=US/ST=New York/L=Brooklyn/O=NYU Mess Lab/OU=Certificate Authority/CN=LLM CTF CA"
