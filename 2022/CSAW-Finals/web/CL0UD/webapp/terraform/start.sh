#!/bin/bash
echo "Generating ssh Keys!!"
ssh-keygen -b 4096 -t rsa -f ./terraform -q -N ""
echo "Done Generating ssh Keys!!"