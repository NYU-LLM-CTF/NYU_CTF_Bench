from flask import Flask, render_template, request, session, jsonify, send_file
from hashlib import sha256
from os import path as path
from datetime import timedelta


app = Flask(__name__)
app.secret_key = 'safe'

leaderboard_path = 'leaderboard.txt'
safetytime = 'csawctf{i_look_different_in_prod}'

app.permanent_session_lifetime = timedelta(minutes=10)


@app.before_request
def ensure_session_id():
    session.permanent = True
    if 'session_id' not in session:
        session['session_id'] = sha256(str(request.remote_addr).encode('utf-8')).hexdigest()


@app.route('/')
def index() -> str:
    cookie = request.cookies.get('session')
    
    if cookie:
        token = cookie.encode('utf-8')
        tokenHash = sha256(token).hexdigest()
        
        if tokenHash == '25971dadcb50db2303d6a68de14ae4f2d7eb8449ef9b3818bd3fafd052735f3b':
            try:
                with open(leaderboard_path, 'r') as file:
                    lbdata = file.read()
            
            except FileNotFoundError:
                lbdata = 'Leaderboard file not found'
            
            except Exception as e:
                lbdata = f'Error: {str(e)}'
                
            return '<br>'.join(lbdata.split('\n'))
    
    session_id = session.get('session_id')
    
    open('logs/' + sha256(session_id.encode('utf-8')).hexdigest() + '.txt', mode='w').close()
    return render_template("index.html")


@app.route('/report')
def report() -> str:
    return render_template("report.html")


@app.route('/clear_logs', methods=['POST'])
def clear_logs() -> Flask.response_class:
    try:
        
        session_id = session.get('session_id')
        
        if not session_id:
            return jsonify(status='error', reason='No Session ID found'), 400
        
        open('logs/' + sha256(session_id.encode('utf-8')).hexdigest() + '.txt', 'w').close()
        
        return jsonify(status='success')
    
    except FileNotFoundError:
        return jsonify(status='success')
    
    except Exception as e:
        return jsonify(status='error', reason=str(e))

    
@app.route('/submit_logs', methods=['POST'])
def submit_logs() -> Flask.response_class:
    try:
        logs = request.json
        
        session_id = session.get('session_id')
        
        if not session_id:
            return jsonify(status='error', reason='No session ID found'), 400
                
        with open('logs/' + sha256(session_id.encode('utf-8')).hexdigest() + '.txt', 'a') as logFile:
            for log in logs:
                logFile.write(f"{log['player']} pressed {log['key']}\n")
        
        return jsonify(status='success')
    
    except Exception as e:
        return jsonify(status='error', reason=str(e))


@app.route('/get_logs', methods=['GET'])
def get_logs() -> Flask.response_class:
    try:
        session_id = session.get('session_id')
        
        if not session_id:
            return jsonify(status='error', reason='No session ID found'), 400
        
        filepath = 'logs/' + sha256(session_id.encode('utf-8')).hexdigest() + '.txt'
        
        if path.exists(filepath):
            return send_file(filepath, as_attachment=False)
        else:
            return jsonify(status='error', reason='Log file not found'), 404
    
    except Exception as e:
        return jsonify(status='error', reason=str(e))


@app.route('/get_moves', methods=['POST'])
def eval_moves() -> Flask.response_class:
    try:
        data = request.json
        reported_player = data['playerName']
        moves = ''
        
        session_id = session.get('session_id')
        
        filepath = 'logs/' + sha256(session_id.encode('utf-8')).hexdigest() + '.txt'
        
        if path.exists(filepath):
            with open(filepath, 'r') as file:
                lines = file.readlines()
                
                for line in lines:
                    if line.strip():
                        player, key = line.split(' pressed ')
                        if player.strip() == reported_player:
                            moves += key.strip()
        
        return jsonify(status='success', result=moves)
    
    except Exception as e:
        return jsonify(status='error', reason=str(e))


@app.route('/get_eval', methods=['POST'])
def get_eval() -> Flask.response_class:
    try:
        data = request.json
        expr = data['expr']
        
        return jsonify(status='success', result=deep_eval(expr))
    
    except Exception as e:
        return jsonify(status='error', reason=str(e))


def deep_eval(expr:str) -> str:
    try:
        nexpr = eval(expr)
    except Exception as e:
        return expr
    
    return deep_eval(nexpr)


if __name__ == '__main__':
    app.run(host='0.0.0.0')