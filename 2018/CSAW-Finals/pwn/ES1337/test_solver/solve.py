#!/usr/bin/env python3

import requests
from urllib.parse import unquote

flag_lines = requests.get('https://moyix.net/~moyix/secret/grepflag.php').text
print(unquote(flag_lines))
