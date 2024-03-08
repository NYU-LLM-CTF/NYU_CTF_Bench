Overview:
- bypass discord webhook validation via cURL globbing {}
- e.g. `http://{hc.lc,localhost,@discord.com:0}{/api/webhooks/1/a?,/xss.php?xss=lol&delay=5,:2019/config/apps/http/servers/srv0/routes/3/handle/0/transport/env}`
  - `url_parse` parses `host => discord.com`, `path => /api/webhooks/1/a`
  - due to url globbing, cURL issues requests to other endpoints
- Caddy serves an admin API on localhost:2019, we can SSRF to this to change config variables
- we are limited on what we can write to, as Caddy has fairly strict type checking (go json unmarshalling)
- however, we can change fastCGI environment variables! `/config/apps/http/servers/srv0/routes/3/handle/0/transport/env`
- `SCRIPT_FILENAME` envvar controls the php script to be executed. we can change this to an arbitrary php file.
- we can use pearcmd gadget for RCE, as it's included in the php:8.2-fpm container

- last issue -- once we overwrite `SCRIPT_FILENAME` envvar, we can't really execute other php files again...
- we get around this by adding delays in our initial cURL invokations, to restore `SCRIPT_FILENAME` after a certain duration

