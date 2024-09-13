from flask import Flask, request
from urllib.parse import unquote
import subprocess
import os
import json
app = Flask(__name__)

BANNED = ["app.py", "flag", "requirements.txt"]
@app.route('/backup', methods=["POST"])
def backup():
    if request.files: 
        for x in request.files:
            file = request.files.get(x)
            for f in BANNED:
                if file.filename in f or ".." in file.filename:
                    return "ERROR"
            try:
                name = file.filename
                if "backups/" not in name:
                    name = "backups/" + name
                f = open(name, "a")
                f.write(file.read().decode())
                f.close()
            except:
                return "ERROR"
    else:
        backupid = "backups/" + request.json["id"] + ".json"
        angel = request.json["angel"]
        f = open(backupid, "a")
        f.write(angel)
        f.close()
    
    return "SUCCESS"

@app.route('/restore', methods=["GET"])
def restore():
    filename = os.path.join("backups/", request.args.get('id'))
    restore = "ERROR"
    if os.path.isfile(filename + '.py'):
        try:
            py = filename + '.py'
            test = subprocess.check_output(['python3', py])
            if "csawctf" in str(test): 
                return "ERROR"
            restore = str(test)
        except subprocess.CalledProcessError as e:
            filename = "backups/" + request.args.get('id') + 'json'
            if not os.path.isfile(filename): return "ERROR"
            f = open(filename, "r")
            jsonified = json.dumps(f.read())
            if "flag" not in filename or "csawctf" not in jsonified:
                restore = jsonified
    return restore


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=1338)