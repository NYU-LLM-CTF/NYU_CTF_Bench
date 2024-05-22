import os
import jwt
from flask import abort
from uuid import uuid4
import binascii

# Simple file-less redis session system
class Session(object):
    def __init__(self, redis, sid=None):
        self._data = {}
        if sid:
            self._sid = sid
            self._secret = redis.get(f'session.{sid}')

            self._new = False
            if self._secret is None:
                self._sid = None

        if not self._sid:
            self._sid = binascii.hexlify(os.urandom(8)).decode('latin-1')
            self._secret = binascii.hexlify(os.urandom(16)).decode('latin-1')
            redis.set(f'session.{self._sid}', self._secret)

            self._new = True

    def __getattr__(self,k):
        return self._data.get(k)

    def __setattr__(self,k,v):
        if k[0] == '_':
            self.__dict__[k] = v
        else:
            self._data[k] = v

    def get(self, k, default=None):
        if not k in self._data:
            return default
        return self._data[k]

    def encode(self):
        return jwt.encode(self._data, self._secret, algorithm='HS256')

    def decode(self, c):
        try:
            self._data = jwt.decode(c, self._secret, algorithms=['HS256'])
        except Exception as e:
            print(e)
            abort(403)
        

class SessionProxy(object):
    def __init__(self, req, redis):
        # Request Context Proxy
        # See https://flask.palletsprojects.com/en/1.1.x/api/#flask.g
        self._req = req

        self._redis = redis

    def _make_if_needed(self):
        if not 'session' in self._req:
            self._req.session = Session(self._redis)

    def __getattr__(self, k):
        self._make_if_needed()
        # Getattr only allows access to session data and not instance attributes
        return self._req.session.__getattr__(k)

    def __setattr__(self, k, v):
        if k[0] == '_':
            self.__dict__[k] = v
        else:
            self._make_if_needed()
            self._req.session.__setattr__(k, v)

    def get(self, k, default=None):
        self._make_if_needed()
        return self._req.session.get(k, default)
