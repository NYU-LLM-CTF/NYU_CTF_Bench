from flask import Flask, request, render_template, jsonify, make_response, redirect, url_for, render_template_string
import jwt
import datetime
import os

app = Flask(__name__)

# Load keys
with open('private_key.pem', 'rb') as f:
    PRIVATE_KEY = f.read()

with open('public_key.pub', 'rb') as f:
    PUBLICKEY = f.read()

KINGSDAY = os.getenv("KINGSDAY", "TEST_TEST")

current_date = datetime.datetime.now()
current_date = current_date.strftime("%d_%m_%Y")

@app.route('/entrance', methods=['GET'])
def entrance():
    payload = {
        "ROLE": "commoner",
        "CURRENT_DATE": f"{current_date}_AD",
        "exp": datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(days=(365*3000))
    }
    token = jwt.encode(payload, PRIVATE_KEY, algorithm="EdDSA")
    
    response = make_response(render_template('pyramid.html'))
    response.set_cookie('pyramid', token)

    return response

@app.route('/hallway', methods=['GET'])
def hallway():
    return render_template('hallway.html')



@app.route('/scarab_room', methods=['GET', 'POST'])
def scarab_room():
    try:
        if request.method == 'POST':
            name = request.form.get('name')
            if name:
                kings_safelist = ['{','}', '𓁹', '𓆣','𓀀', '𓀁', '𓀂', '𓀃', '𓀄', '𓀅', '𓀆', '𓀇', '𓀈', '𓀉', '𓀊', 
                                    '𓀐', '𓀑', '𓀒', '𓀓', '𓀔', '𓀕', '𓀖', '𓀗', '𓀘', '𓀙', '𓀚', '𓀛', '𓀜', '𓀝', '𓀞', '𓀟',
                                    '𓀠', '𓀡', '𓀢', '𓀣', '𓀤', '𓀥', '𓀦', '𓀧', '𓀨', '𓀩', '𓀪', '𓀫', '𓀬', '𓀭', '𓀮', '𓀯',
                                    '𓀰', '𓀱', '𓀲', '𓀳', '𓀴', '𓀵', '𓀶', '𓀷', '𓀸', '𓀹', '𓀺', '𓀻']  

                name = ''.join([char for char in name if char.isalnum() or char in kings_safelist])

                
                return render_template_string('''
                    <!DOCTYPE html>
                    <html lang="en">
                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Lost Pyramid</title>
                        <style>
                            body {
                                margin: 0;
                                height: 100vh;
                                background-image: url('{{ url_for('static', filename='scarab_room.webp') }}');
                                background-size: cover;
                                background-position: center;
                                background-repeat: no-repeat;
                                font-family: Arial, sans-serif;
                                color: white;
                                position: relative;
                            }

                            .return-link {
                                position: absolute;
                                top: 10px;
                                right: 10px;
                                font-family: 'Noto Sans Egyptian Hieroglyphs', sans-serif;
                                font-size: 32px;
                                color: gold;
                                text-decoration: none;
                                border: 2px solid gold;
                                padding: 5px 10px;
                                border-radius: 5px;
                                background-color: rgba(0, 0, 0, 0.7);
                            }

                            .return-link:hover {
                                background-color: rgba(0, 0, 0, 0.9);
                            }

                            h1 {
                                color: gold;
                            }
                        </style>
                    </head>
                    <body>
                        <a href="{{ url_for('hallway') }}" class="return-link">RETURN</a>
                        
                        {% if name %}
                            <h1>𓁹𓁹𓁹 Welcome to the Scarab Room, '''+ name + ''' 𓁹𓁹𓁹</h1>
                        {% endif %}
                        
                    </body>
                    </html>
                ''', name=name, **globals())
    except Exception as e:
        pass 

    return render_template('scarab_room.html')

@app.route('/osiris_hall', methods=['GET'])
def osiris_hall():
    return render_template('osiris_hall.html')

@app.route('/anubis_chamber', methods=['GET'])
def anubis_chamber():
    return render_template('anubis_chamber.html')

@app.route('/')
def home():
    return redirect(url_for('entrance'))

@app.route('/kings_lair', methods=['GET'])
def kings_lair():
    token = request.cookies.get('pyramid')
    if not token:
        return jsonify({"error": "Token is required"}), 400

    try:
        decoded = jwt.decode(token, PUBLICKEY, algorithms=jwt.algorithms.get_default_algorithms())
        if decoded.get("CURRENT_DATE") == KINGSDAY and decoded.get("ROLE") == "royalty":
            return render_template('kings_lair.html')
        else:
            return jsonify({"error": "Access Denied: King said he does not way to see you today."}), 403
    
    except jwt.ExpiredSignatureError:
        return jsonify({"error": "Access has expired"}), 401
    except jwt.InvalidTokenError as e:
        print(e)
        return jsonify({"error": "Invalid Access"}), 401

if __name__ == '__main__':
    app.run(host = '0.0.0.0', port = 8050)
