#!/usr/bin/python3
import subprocess
import uuid
import stat
import os
import requests

url = input("Where are you sending me this from?>>>")

r = requests.get(url, stream=True)

tmpfile_path = "/tmp/" + str(uuid.uuid4())

with open(tmpfile_path, "wb") as f:
    for chunk in r.iter_content(chunk_size=1024):
        if chunk:
            f.write(chunk)

st = os.stat(tmpfile_path)
env = {"LD_PRELOAD": tmpfile_path}

subprocess.run("./mystery_boi", env=env)
