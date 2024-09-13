# Challenge

> csawctf{5h1tt4k3_mu5hr00m5_i_fuXOR3d_up_r34l_b4d}

## Description

This challenge is intended to test one's familiarity with a Javascript obfuscication tool JSFuck (pardon the obscenity) and XSS attacks.

## Tools

These will be needed to help install/solve challange

- docker
- python
- selenium

## Installation

```bash
./install.sh
```

## Solution

### Autosolver

```bash
python3 solution.py
```

### Manual solution

From the provided source code, identify the variable *safetime* in the server script, which holds the authentication cookie.

Encode *safetytime* in JSFuck. The encoding is one-to-many, so let's work with *(![]+[])[!+[]+!+[]+!+[]]+(![]+[])[+!+[]]+(![]+[])[+[]]+(!![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(+[![]]+[+(+!+[]+(!+[]+[])[!+[]+!+[]+!+[]]+[+!+[]]+[+[]]+[+[]]+[+[]])])[+!+[]+[+[]]]+(!![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+((+[])[([][(![]+[])[+[]]+(![]+[])[!+[]+!+[]]+(![]+[])[+!+[]]+(!![]+[])[+[]]]+[])[!+[]+!+[]+!+[]]+(!![]+[][(![]+[])[+[]]+(![]+[])[!+[]+!+[]]+(![]+[])[+!+[]]+(!![]+[])[+[]]])[+!+[]+[+[]]]+([][[]]+[])[+!+[]]+(![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[])[+!+[]]+([][[]]+[])[+[]]+([][(![]+[])[+[]]+(![]+[])[!+[]+!+[]]+(![]+[])[+!+[]]+(!![]+[])[+[]]]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[][(![]+[])[+[]]+(![]+[])[!+[]+!+[]]+(![]+[])[+!+[]]+(!![]+[])[+[]]])[+!+[]+[+[]]]+(!![]+[])[+!+[]]]+[])[+!+[]+[+!+[]]]+(!![]+[])[!+[]+!+[]+!+[]]* as the encoding.

Bind one of the players to the keys (,),[,],!,+ in any order. Proceed to input our encoded payload as moves. After inputting the payload, move to the reporting page and report the player name for our payload.

The report script will display the authentication token. After visitng the home page with the authentication cookie, the leaderboard will be displayed. We can find the flag as one of the entries on this list.

Voilà