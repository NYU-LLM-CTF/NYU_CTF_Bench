# Challenge

> csawctf{$$king$_confusion$$$}

## Description

This challenge involves an algorithm confusion attack with an old vulnerable version of PyJWT. Tokens are signed using EdDSA (a public key algorithm). However, when the tokens are being decoded, jwt.algorithms.get_default_algorithms() is used. This allows an attacker to sign a forged token with the public key and change the algorithm to a symmetric algorithm (like HS256). The public key in this challenge can be leaked via an SSTI vulnerability on one of the pages.

## Tools

These will be needed to help install/solve challenge:

- Docker
- Python

## Installation

./install.sh

## Solution

### Step 1 - Leak Public Key
Participants should be quick to realize that there is an SSTI vulnerability within the '/scarab_room' endpoint. This page uses render_template_string and passes in globals(). The vast majority of symbols are filtered by the server, however, they still have access to '{' and '}' importantly. This way PUBLICKEY can be leaked via the payload {{ PUBLICKEY }} and a key component of the JWT can be leaked via {{ KINGSDAY }}.

### Step 2 - Create Proper Payload
The /kings_lair endpoint is where the flag is stored. To access this, the JWT needs to have the following claims set:
"ROLE" set to "royalty" and "CURRENT_DATE" set to the proper date specified by the global variable "KINGSDAY". Once this payload is created, participants can set the token's algorithm to a symmetric algo like HS256 and sign this token with the leaked public key.

Note that the server runs pyjwt version 2.3.0, newer versions do not have this vulnerability. Competitors will have to use this old version as newer versions will refuse to use asymmetric keys as symmetric keys.

### Step 3 - Replace the "pyramid" cookie
After Step 2, one just needs to replace the "pyramid" cookie with the forged token and refresh the /kings_lair endpoint.
