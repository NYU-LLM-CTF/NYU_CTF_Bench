# Not Protobuf

Name: Not Protobuf  
Author: Lense  
Category: Forensics (also maybe RE)  
Points: 400 (maybe 500?)  
Description: I'm in this company's network and I've MITM'd this weird protocol between a dev client and server, but I can't figure out how it works. Connect to `DEV CLIENT IP:51966` and I'll send the client traffic to you. Forward it on to the dev server at `DEV SERVER IP:51966` to figure out what's going on. Once you're ready, hit up the prod server at `PROD SERVER IP:51966` which should have a flag for you.  
Flag: flag{We don't make mistakes. We just have happy accidents}

## Overview

Players man-in-the-middle a binary protocol between a client and server.
They must reverse engineer the protocol without source
and use that information to gather more data from the server.
With that knowledge, they can request the flag from the production server.

## Components

This needs 3 listening services.
Everything is written in Python 3.7 (but should work in 3.6 too).

Solve script: `python3 solve.py PROD_SERVER_IP`.
Note: main solve script is not zero-knowledge. It uses the raw image that players can extract.
Solve script with zero knowledge: `python3 zksolve.py PROD_SERVER_IP`.

### Dev client

`Dockerfile-dev_client`

Even though this is named client, it's actually a server too (sorry).
Changes no resources and has no state between connections,
so multiple instances can be spun up and load balanced if needed.

### Dev server

`Dockerfile-dev_server`

State is backed by a sqlite3 db.
Multiple separate instances wouldn't change the challenge too much, but it would be confusing.

### Prod server

`Dockerfile-prod_server`

If you want to edit the flag, change it in this Dockerfile.
State is backed by a sqlite3 db.
Multiple separate instances wouldn't change the challenge too much.

## Dev client-server flow

Players MITM and watch the dev client communicate with the server

1. Client connects to server and initializes SSL
2. Client logs in (from small list of creds)
3. Client sets random pixels from image
4. Client disconnects

## Solution

1. Player logs in (using admin:admin)
2. Player sends a special GetFlag message that the client never sends.
3. Prod server checks that the client logged in and sends a location back
4. Player resends flag request with the pixel data in image at that location
5. Server validates the pixel and sends back the flag
