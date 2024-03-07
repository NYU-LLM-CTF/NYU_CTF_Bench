import tempfile
import sys,os
import signal

EOF_TOKEN = "<EOF>"

def _print(content):
	print(content)
	sys.stdout.flush()

def initialize():
    signal.alarm(50)
    os.chdir(sys.path[0])

def status_check():
    d8_path = "d8"
    if not os.path.isfile(d8_path):
        _print("Contact admin, challenge is broken (d8_not_present)")
    if not os.access(d8_path, os.X_OK):
        _print("Contact admin, challenge is broken (d8_not_executable)")

if __name__ == "__main__":
    initialize()
    status_check()
    pay = ""
    _print("Send your code, ending with {}".format(EOF_TOKEN))
    while(1):
        line = input()
        if line.strip() == EOF_TOKEN:
            break
        pay += (line + "\n")
    f = tempfile.NamedTemporaryFile(prefix='', suffix='.js',delete=False)
    f.write(pay.encode())
    f.close()
    _print("Not we wil run your *.js with d8")
    os.close(1)
    os.close(2)
    os.system("/home/ctf/d8 %s --allow-natives-syntax"%f.name)
    _print("done!")
    os.unlink(f.name)
