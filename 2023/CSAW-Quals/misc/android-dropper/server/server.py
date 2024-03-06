from flask import Flask, request, make_response
import socket
import os
import base64


SERVER_HOSTNAME = socket.gethostname()
SERVER_IP = socket.gethostbyname(SERVER_HOSTNAME)
PID = str(os.getpid())

print("HTTP Server started on: " + SERVER_HOSTNAME + " with IP: " + SERVER_IP + "\nPID: " + PID)
app = Flask(__name__)

# put offsets and xor number used in obf() here
off1 = 275 
off2 = 306
xorKey = 42 

line = 'For instance, on the planet Earth, man had always assumed that he was more intelligent than dolphins because he had achieved so much - the wheel, New York, wars and so on - whilst all the dolphins had ever done was muck about in the water having a good time. But conversely, the dolphins had always believed that they were far more intelligent than man - for precisely the same reasons.'

with open("/home/ctf/flag.txt") as f:
    flag = f.readline()
response = line[:off1] + flag + line[off1:]
responseCipher = bytearray()

for c in response:
    responseCipher.append( ord(c) ^ xorKey )
#    print(f"{c}: {str(ord(c))}")
b64ed = base64.b64encode(responseCipher)


@app.route('/', methods=['GET'])
def process_command():
    client_ip = request.remote_addr
    print("[*] incoming request from IP: " + client_ip)
    return make_response(b64ed)


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=3003)
