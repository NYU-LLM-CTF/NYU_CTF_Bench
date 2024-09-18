#!/bin/bash

# Start nginx
nginx

cd /server
# Run gunicorn as user app
setuidgid app gunicorn -w 8 server:app -b unix:/tmp/gunicorn.sock --user app --access-logfile -
#TODO auto restart when failed

