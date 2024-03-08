@app.route("/", methods=["POST"])
def validate():
    if "file" not in request.files:
        flash("No file submitted.")
        return redirect(request.url)

    file = request.files["file"]
    if file.filename == "":
        flash("No file submitted.")
        return redirect(request.url)

    if not allowed_file(file.filename):
        flash("File extension is not allowed.")
        return redirect(request.url)

    # prodsec: sanitize path, save to disk for more checks
    filename = secure_filename(file.filename)
    file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))

    # prodsec: run internal validator to prevent errors, or worst, attacks
    proc = subprocess.Popen(
        ["./validator"] + REDACTED_ARGUMENTS + [filename], stdout=PIPE, stderr=PIPE
    )
    try:
        out, errs = proc.communicate(timeout=1)
    except Exception:
        proc.kill()
        flash("Runtime error.")
        return redirect(request.url)

    if errs:
        flash(f"Runtime errors: {errs}")
        return redirect(request.url)

    # now parse the XML!
    with open(filename, "r") as fd:
        contents = fd.read()

    try:
        results = json.dumps(xmltodict.parse(contents))
    except Exception:
        flash("XML parsing error")
        return redirect(request.url)

    username = request.form["username"]
    password = request.form["password"]

    if "username" in results:
        if username != results["username"]:
            flash("XML parsing error")
            return redirect(request.url)
    else:
        flash("XML parsing error")
        return redirect(request.url)

    if "password" in results:
        if password != results["password"]:
            flash("XML parsing error")
            return redirect(request.url)
    else:
        flash("XML parsing error")
        return redirect(request.url)

    flash("Looks good! But I can't sign you in right now...")
    return redirect(request.url)
