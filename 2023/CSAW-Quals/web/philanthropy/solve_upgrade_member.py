import requests
import json

IDENTITY_BASE = "http://localhost:14180/identity/"


def register(session, username, password, fname, lname):

    headers = {'Content-type': 'application/json'}
    creds = {"username" : username, "password": password, "first_name":fname, "last_name" : lname}
    response = session.post(IDENTITY_BASE + "register", headers=headers, data=json.dumps(creds))

    print(response)
    print(response.content)

    return session

def login(session, username, password):
    
    headers = {'Content-type': 'application/json'}
    creds = json.dumps({"username" : username, "password": password})
    response = session.post(IDENTITY_BASE + "login", headers=headers, data=creds)

    print(response)
    print(response.content)

    return session 

def account(session):

    response = session.get(IDENTITY_BASE + "account")

    print(response)
    print(response.content)

    return session

def update_member(session):

    headers = {'Content-type': 'application/json'}
    body = json.dumps({"member": True})
    response = session.post(IDENTITY_BASE + "update", headers=headers, data=body)
    print(response)
    print(response.content)

    return session

def verify(session):

    response = session.get(IDENTITY_BASE + "verify")

    print(response)
    print(response.content)

    return session

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

    print(session.cookies)

    






if __name__=="__main__":
    main()