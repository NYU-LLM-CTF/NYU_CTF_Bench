import hashlib
import base64

c = b"wakuwaku"

for _ in range(1000):
    hash = hashlib.sha256()
    hash.update(c)
    c = hash.digest()

print(c)
print(base64.b64encode(c))