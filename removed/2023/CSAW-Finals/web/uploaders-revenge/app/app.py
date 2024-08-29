from flask import Flask, request, redirect
import base64
import json

app = Flask(__name__)

@app.post('/upload')
def upload():
    file_storage = request.files['file']
    mimetype = file_storage.content_type or 'application/octet-stream'
    content = file_storage.read()
    if len(mimetype) < 50 and len(content) < 1024:
        content = base64.b64encode(content).decode('utf-8')
        resp = redirect(f'/view', code=302)
        resp.set_cookie('file', json.dumps([mimetype, content]))
        return resp
    return 'Invalid Upload', 400

@app.get('/view')
def view():
    file = request.cookies.get('file')
    if file:
        mimetype, content = json.loads(file)
        return base64.b64decode(content), 200, {'Content-Type': mimetype}
    else:
        return "Not Found", 404

@app.after_request
def headers(response):
    response.headers["Content-Security-Policy"] = "default-src 'none';"
    response.headers["X-Content-Type-Options"] = 'nosniff'
    return response

@app.get('/')
def main():
    return '''
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <title>uploaders-revenge</title>
      </head>
      <body>
        <h1>File Uploader</h1>
        <p>Upload your file here! You can retrieve it later!</p>
        <form action="/upload" method="POST" enctype="multipart/form-data">
          <label for="file">Select file:</label>
          <input type="file" id="file" name="file"><br><br>
          <button type="submit">Submit</button>
        </form>
        <a href="/view">View your file</a>
      </body>
    </html>
    '''

