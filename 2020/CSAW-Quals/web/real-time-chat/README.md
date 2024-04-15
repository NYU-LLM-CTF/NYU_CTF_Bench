# Web Real Time Chat

Category: Web
Suggested Points: 450
Distribute: Dockerfile, app.py, supervisord.conf, and link to hosted chal

## Description

I started playing around with some fancy new Web 3.1 technologies!
This RTC tech looks cool, but there's a lot of setup to get it working...
I hope it's all secure.

## Deployment

The dockerfile EXPOSEs 2 ports, one for the web interface, and one for coTURN.
It's probably best to leave coTURN on 3478, and that port is hard-coded into the chal in `static/rtc.js`.
coTURN is also configured to use UDP 49000-49100 for transport, however I can't get that to work for whatever reason,
so those ports don't _have_ to be forwarded.

## Flag

`flag{ar3nt_u_STUNned_any_t3ch_w0rks_@_all?}`

## Intended Solution

* Load the challenge, look through source, find a custom TURN server URL is used
* Research how WebRTC works, what TURN servers are, and realize how they are basically proxies
* Potentially research previous exploitation of TURN servers, probably discovering [https://www.rtcsec.com/2020/04/01-slack-webrtc-turn-compromise/](https://www.rtcsec.com/2020/04/01-slack-webrtc-turn-compromise/)
* Create a tool (or find [https://raw.githubusercontent.com/trichimtrich/turnproxy/master/turnproxy.py](https://raw.githubusercontent.com/trichimtrich/turnproxy/master/turnproxy.py)) to proxy arbitrary connections through the TURN server
* Attempt to connect to redis, but discover you can't connect to `127.0.0.1`
* Circumvent by connecting to `0.0.0.0` (or brute forcing the container IP)
* Use metasploit or whatever to RCE redis and read out the flag

## Potential breakage

* Bad exploits taking down redis
    * supervisord should autorestart
* Intentional DoS on redis (constant `FLUSHALL` or similar)
    * Redis having data isn't technically necessary for the chal - just for the demo page to work
