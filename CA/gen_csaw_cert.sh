#!/usr/bin/env bash

openssl genrsa -out csaw.io.key 2048
openssl req -new -key csaw.io.key -out csaw.io.csr
cat > csaw.io.ext <<"EOF"
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.csaw.io
DNS.2 = csaw.io
EOF
openssl x509 -req -in csaw.io.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out csaw.io.crt -days 825 -sha256 -extfile csaw.io.ext -subj -subj "/C=US/ST=New York/L=Brooklyn/O=NYU Mess Lab/OU=LLM CTF/CN=*.csaw.io"
