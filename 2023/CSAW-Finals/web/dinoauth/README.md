
# dinoauth web
OAuth challenge. The goal is to get an access token utilizing a scope-upgrade attack, and then to hit the`/buy_flagosaurus` endpoint.

# Authors
gchip, rollingcoconut

# Design
* The website is built on Koa Oauth libraries sourced online with MIT licences. The client application (port 3001) communicates for authorizations and resources with the the backend sever (port 3002). The backend has 2 routes, `/oauth/` and `/api/`. 

* The oauth flow is as follows: 
    * The client application (e.g.dinomarket_app) requests a code from the `/oauth/authorize` endpoint; 
    * It then sends that code to `/oauth/token` to get a token; 
    * It then uses the token to access the server resources behind `/api/` (ie `buy_dino`, `sell_dino`). 

In this challenge the resource server and oauth server run on the same port.  


# Deployment
`docker build -t dinoauth .`

`docker run -d -p 3001:3001 -p 3002:3002 dinoauth`

* When deploying, change HOST environment variable in `Dockerfile`

# Solution
The challenge has three main steps \

(1) Fuzz the `/oauth/` route to find the `/oauth/debug` endpoint. This is a hardcoded endpoint that reveals a second client_id, `dinomaster_app`, its client_secret, and the upgraded scope `buy_flagosaurus`. This endpoint also reveals the `/oauth/token` endpoint used in the next step.

(2) Send a get request to `/oauth/authorize` using the `dinomaster_app` client_id and scope (with correct state, csrfToken, and `agree=true`) to receive the authorization code. Then send a post request to `/oauth/token` with this code to receive the `access_token` and `refresh_token`.

(3) Send a get request to `/buy_flagosaurus` with the `koa:sess` cookie edited with the correct state, csrfToken, and token from previous step. In order for the session token to be accepted by koa, the `koa:sess.sig` cookie also has to be set (https://stackoverflow.com/questions/48158582/what-is-koasess-sig). This is created by base64 encoding the sha1 hashed `koa:sess` cookie with the koa-session-key (The key is found in the comments of the inventory page. Players should notice the only dinosaur they own is a Koasigsessasaurus which tells them that this is the session key).
