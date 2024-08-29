from flask import Flask,render_template,request
from hashlib import sha256
from time import perf_counter



app = Flask(__name__)



@app.route('/')
def form():

    return render_template('form.html')

@app.route('/keylogger/', methods = ['POST', 'GET'])
def keylogger():

    if request.method == 'GET':
        return f"this is not it"

    if request.method == 'POST':
        form_data = request.form

        password = form_data["password"].strip()
        resultant_hash = form_data["resultant_hash"].strip()




        if resultant_hash != '0000018d5443869adce6e469f17aa0ee87221eb61d63f2bb8d3a2d91ce7a90fa':
            if password == '1337speak':
                return '<a> you got this far but are you 1337!? go back and figure out the proof of work! </a>'
            elif password == '1337speak83497':
                return '<a> good so you figured it out but without the resultant hash you are never going to get the flag </a>'


        if resultant_hash=='0000018d5443869adce6e469f17aa0ee87221eb61d63f2bb8d3a2d91ce7a90fa' and password=='1337speak83497':
            return '<h1> csawctf{itTookThisManyTries}</h1>'
        else:
            return render_template('form.html')


if __name__ =="__main__":
    app.run(host='0.0.0.0', port=4999)
