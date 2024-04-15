import os
# import magic
import requests
from flask import Flask, flash, request, redirect, render_template
import werkzeug
import face_recognition

ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg', 'gif'])

from flask import Flask

app = Flask(__name__)

app.secret_key = "secret key"
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/')
def upload_form():
    # return "Hello client"
    return render_template('upload.html')


@app.route('/', methods=['POST'])
def upload_file():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'username' not in request.form:
            flash('No username part')
            return redirect(request.url)
        username = request.form['username']
        if 'file' not in request.files:
            flash('No file part')
            return redirect(request.url)
        file = request.files['file']
        if file.filename == '':
            flash('No file selected for uploading')
            return redirect(request.url)
        if file and allowed_file(file.filename):
            encoding= get_biometric_encoding(file)
            if encoding is None:
                flash("Error processing image")
                return redirect(request.url)

            payload = {"username":username,"encoding":encoding}
            server = os.getenv("server", default="http://0.0.0.0:5001")
            resp = requests.post(url=server,json =payload)

            return resp.content
        else:
            flash('Allowed file types are png, jpg, jpeg, gif')
            return redirect(request.url)


def get_biometric_encoding(file:werkzeug.FileStorage):

    try:
        image = face_recognition.load_image_file(file)
        encoding = face_recognition.face_encodings(image)[0].tolist()
    except:
        return None
    return encoding


if __name__ == "__main__":
    port = os.getenv("port", default="5000")
    app.run(host="0.0.0.0", port=port)