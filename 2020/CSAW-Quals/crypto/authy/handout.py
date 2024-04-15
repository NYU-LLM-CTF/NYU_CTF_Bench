#!/usr/bin/env python3
import struct
import hashlib
import base64
import flask

# flag that is to be returned once authenticated
FLAG = ":p"

# secret used to generate HMAC with
SECRET = ":p".encode()

app = flask.Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def home():
    return """
This is a secure and private note-taking app sponsored by your favorite Nation-State.
For citizens' convenience, we offer to encrypt your notes with OUR own password! How awesome is that?
Just give us the ID that we generate for you, and we'll happily decrypt it back for you!

Unfortunately we have prohibited the use of frontend design in our intranet, so the only way you can interact with it is our API.

/new

    DESCRIPTION:
        Adds a new note and uses our Super Secure Cryptography to encrypt it.

    POST PARAMS:
        :author: your full government-issued legal name
        :note: the message body you want to include. We won't read it :)

    RETURN PARAMS:
        :id: an ID protected by password  that you can use to retrieve and decrypt the note.
        :integrity: make sure you give this to validate your ID, Fraud is a high-level offense!


/view
    DESCRIPTION:
        View and decrypt the contents of a note stored on our government-sponsored servers.

    POST PARAMS:
        :id: an ID that you can use to retrieve and decrypt the note.
        :integrity: make sure you give this to validate your ID, Fraud is a high-level offense!

    RETURN PARAMS:
        :message: the original unadultered message you stored on our service.
"""

@app.route("/new", methods=["POST"])
def new():
    if flask.request.method == "POST":

        payload = flask.request.form.to_dict()
        if "author" not in payload.keys():
            return ">:(\n"
        if "note" not in payload.keys():
            return ">:(\n"

        if "admin" in payload.keys():
            return ">:(\n>:(\n"
        if "access_sensitive" in payload.keys():
            return ">:(\n>:(\n"

        info = {"admin": "False", "access_sensitive": "False" }
        info.update(payload)
        info["entrynum"] = 783

        infostr = ""
        for pos, (key, val) in enumerate(info.items()):
            infostr += "{}={}".format(key, val)
            if pos != (len(info) - 1):
                infostr += "&"

        infostr = infostr.encode()

        identifier = base64.b64encode(infostr).decode()

        hasher = hashlib.sha1()
        hasher.update(SECRET + infostr)
        return "Successfully added {}:{}\n".format(identifier, hasher.hexdigest())


@app.route("/view", methods=["POST"])
def view():

    info = flask.request.form.to_dict()
    if "id" not in info.keys():
        return ">:(\n"
    if "integrity" not in info.keys():
        return ">:(\n"

    identifier = base64.b64decode(info["id"]).decode()
    checksum = info["integrity"]

    params = identifier.replace('&', ' ').split(" ")
    note_dict = { param.split("=")[0]: param.split("=")[1]  for param in params }

    encode = base64.b64decode(info["id"]).decode('unicode-escape').encode('ISO-8859-1')
    hasher = hashlib.sha1()
    hasher.update(SECRET + encode)
    gen_checksum = hasher.hexdigest()

    if checksum != gen_checksum:
        return ">:(\n>:(\n>:(\n"

    try:
        entrynum = int(note_dict["entrynum"])
        if 0 <= entrynum <= 10:

            if (note_dict["admin"] not in [True, "True"]):
                return ">:(\n"
            if (note_dict["access_sensitive"] not in [True, "True"]):
                return ">:(\n"

            if (entrynum == 7):
                return "\nAuthor: admin\nNote: You disobeyed our rules, but here's the note: " + FLAG + "\n\n"
            else:
                return "Hmmmmm...."

        else:
            return """\nAuthor: {}
Note: {}\n\n""".format(note_dict["author"], note_dict["note"])

    except Exception:
        return ">:(\n"

if __name__ == "__main__":
    app.run()
