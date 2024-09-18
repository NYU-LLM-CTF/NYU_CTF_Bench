import socketserver
from subprocess import run, PIPE

class MyTCPHandler(socketserver.BaseRequestHandler):

  def handle(self):

    self.request.send("Give me two args, space separated:\n".encode('utf-8'))

    data = self.request.recv(1024).strip()
    [arg1, arg2] = data.split(b' ')

    print(b"Requested arguments " + arg1 + b" " + arg2)

    res = run(["./callsite", arg1, arg2], stdout=PIPE)
    print(res)
    self.request.sendall(res.stdout)

  
if __name__ == '__main__':
  HOST, PORT = '0.0.0.0', 8000

  server = socketserver.TCPServer((HOST, PORT), MyTCPHandler)

  server.serve_forever()

