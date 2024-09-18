#!/bin/bash

openssl dsaparam -genkey 2048 -out ctf.key
docker build -t csaw .
