from flask import Flask, render_template, request, redirect, url_for, flash, make_response
import requests
import datetime
import jwt
import ipaddress
import urllib3

urllib3.disable_warnings()
SECRET_KEY = "6:2NFfWFI7)Eq6Ft7=%qA!6Y2)4O_~4^2osdjo#u2kC&Hzq)$GAicyByv^TdPp+"

app = Flask(__name__,template_folder='template')

# app name
@app.errorhandler(404)
  
# inbuilt function which takes error as parameter
def not_found(e):
  
# defining function
  return render_template("404.html")


@app.route('/',methods=['GET'])
def index():
    return render_template('index.html')


@app.route('/rockyou',methods=['GET'])
def notes():
    return render_template('notes.html')


@app.route('/developer/heaven',methods=['GET'])
def devbackup():
    if 'secret' not in request.cookies:
        return render_template('/dev/403.html')
    if 'secret' in request.cookies:
        try:
            decode_data = jwt.decode(jwt=request.cookies.get('secret'), key=SECRET_KEY, algorithms="HS256")
            return render_template('/dev/devbackup.html')
        except Exception as e:
            return render_template('/dev/403.html')
    else:
        return render_template('/dev/403.html')

@app.route('/secret',methods=['GET'])
def tokengen():
    json_data = {
    "sender": "secret",
    "message": "A useful piece of the quest.!",
    "date": str(datetime.datetime.now()),
    "exp": datetime.datetime.utcnow() + datetime.timedelta(seconds=86400)
    }
    encode_data = jwt.encode(payload=json_data, key=SECRET_KEY, algorithm="HS256")
    return encode_data

@app.route('/magiccall')
def magiccall():
    temp_location = request.args['pathtojwel']
    temp_target =request.args['location']
    progress = []
    try:
        ipaddress.IPv4Network(temp_target)
        progress = ["Good Progress!! Keep it up."]

        if temp_target == "169.254.169.254":
            temp_target = "localhost:1338"
            finalcall = "http://"+temp_target+"/"+temp_location
            r_content = requests.get(finalcall,verify=False).text.split("\n")
            progress.extend(r_content)
        else:
            progress.append("I can only make calls to Amazon meta data")
        return render_template('result.html',result=progress)
    except Exception as ex:
        return render_template('result.html',result="No Result Found")



if __name__ == '__main__':
    app.run(debug=False, host="0.0.0.0")
