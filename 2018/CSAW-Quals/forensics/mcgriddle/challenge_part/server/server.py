from flask import Flask, request

moveslist = []
with open('final','r') as infile:
    moveslist = infile.read().replace(' ','').split('\n')
print (moveslist)
app = Flask(__name__)
@app.route('/', methods=['GET'])
def index():
    return "Welcome to the game"

@app.route('/move', methods=['POST'])
def move():
    movement = request.form['move']
    next_move = moveslist[moveslist.index(movement) + 1]
    return next_move 

@app.route('/image', methods=['POST'])
def image():
    return "Noted."

if __name__ == '__main__':
    app.run(host='0.0.0.0')
