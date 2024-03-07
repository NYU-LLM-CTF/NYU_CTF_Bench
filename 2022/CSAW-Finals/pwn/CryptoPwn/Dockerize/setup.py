#!/usr/bin/python3
from pathlib import Path
import subprocess
pwd = Path(".") / "chal"

def call(cmd,cwd):
    return subprocess.check_call(cmd,shell=True,cwd=cwd)
    
def init(name):
    call("wget https://raw.githubusercontent.com/n132/ctf_xinetd/master/Dockerfile",pwd)
    call("wget https://raw.githubusercontent.com/n132/ctf_xinetd/master/ctf.xinetd",pwd)
    call("wget https://raw.githubusercontent.com/n132/ctf_xinetd/master/docker-compose.yml",pwd)
    call("wget https://raw.githubusercontent.com/n132/ctf_xinetd/master/start.sh",pwd)
    call("mkdir bin",pwd)
    call("mkdir tmp",pwd)
    call("mkdir run", pwd/"bin")
    call(f"cp ../chal/{name} ./chal/bin/run/chal",Path("."))
    call(f"cp ../chal/flag ./chal/bin/flag",Path("."))
    
def clean():
    call("rm -rf chal",Path("."))
    print("[+] Clean")

def build():
    pwd.mkdir()
    init("cryptown")
    # additional op
    call(f"cp ../chal/logo ./chal/bin/run/logo",Path("."))
    call(f"cp ../chal/samples ./chal/bin/run/samples",Path("."))
    # start.sh
    with open("./chal/bin/start.sh","w+") as f:
        f.write(f"cd ./run && timeout 120 ./chal\n")
    call("chmod +x ./chal/bin/start.sh",Path("."))
    call("chmod +x ./chal/bin/run/chal",Path("."))
    print("[+] Build")

def up():
    call("docker compose build",pwd)
    subprocess.Popen("docker compose up".split(" "),cwd=pwd)    
    print("[+] Up")
def down():
    cur = Path(".")
    for x in range(5):
        cwd = cur/("chal"+str(x+1))
        subprocess.Popen("docker compose stop".split(" "),cwd=cwd)
        print("[+] chal"+str(x+1)+" down")
            
    print("[+] Down")
import sys
if __name__ == "__main__":
    if(len(sys.argv)==1):
        print("Usage: python3 ./setup  [ build, clean, up, down ]")
    elif len(sys.argv)==2:
        if(sys.argv[1]=="build"):
            build()
        elif(sys.argv[1]=="clean"):
            clean()
        elif(sys.argv[1]=="up"):
            up()
        elif(sys.argv[1]=="down"):
            down()
        else:
            print("Usage: python3 ./setup  [ build, clean, up, down ]")
    else:
        print("Usage: python3 ./setup  [ build, clean, up, down ]")