#!/usr/bin/python3
from pathlib import Path
import subprocess
cur = Path(".")
def call(cmd,cwd):
    return subprocess.check_call(cmd,shell=True,cwd=cwd)

def init(stage):
    wkdir = cur/stage
    call("wget https://raw.githubusercontent.com/n132/ctf_xinetd/master/Dockerfile",wkdir)
    call("wget https://raw.githubusercontent.com/n132/ctf_xinetd/master/ctf.xinetd",wkdir)
    call("wget https://raw.githubusercontent.com/n132/ctf_xinetd/master/docker-compose.yml",wkdir)
    call("wget https://raw.githubusercontent.com/n132/ctf_xinetd/master/start.sh",wkdir)
    with open(wkdir/"docker-compose.yml",'r') as f:
        data = f.read()
    data = data.replace("60001",str(60000+int(stage[-1])))
    with open(wkdir/"docker-compose.yml",'w') as f:
        f.write(data)
    call("mkdir tmp",wkdir)
    bin_dir = wkdir / "bin"
    bin_dir.mkdir()
    (bin_dir/"run").mkdir()
    call("cp ./logo "+str(bin_dir/"run"),cur)

    with open(bin_dir/"start.sh","w+") as f:
        f.write(f"cd ./run && cat ./logo &&timeout 120 ./chal\n")
    call("chmod +x start.sh",bin_dir)

    call(f"cp ../public/bin/all/{stage} ./{stage}/bin/run/chal", cur)
    call(f"chmod +x ./{stage}/bin/run/chal",cur)
    call(f"cp ../chal/{stage}/flag ./{stage}/bin/", cur)
    if(Path(f"../chal/{stage}/ticket").exists()):
        call(f"cp ../chal/{stage}/ticket ./{stage}/bin/run/",cur)
    else:
        call(f"touch ./{stage}/bin/ticket",cur)
    
def builder(stage="chal1"):
    work_dir = cur / stage
    try:
        work_dir.mkdir(exist_ok=False)
    except:
        print("[-] Fail to mkdir")
        exit(1)
    init(stage)
    print(f"[+] Built {stage}")

def clean():
    call("rm -rf ./chal1 ./chal2 ./chal3 ./chal4",cur)
    print("[+] Clean Done")

def build():
    for x in range(1,5):
        builder("chal"+str(x))
def up():
    for x in range(4):
        cwd = cur/("chal"+str(x+1))
        call("docker compose build",cwd)
        subprocess.Popen("docker compose up".split(" "),cwd=cwd)
        print("[+] chal"+str(x+1)+" up")
            
    print("Up Done")
def down():
    
    for x in range(4):
        cwd = cur/("chal"+str(x+1))
        subprocess.Popen("docker compose stop".split(" "),cwd=cwd)
        print("[+] chal"+str(x+1)+" down")
            
    print("Down Done")
import sys
if __name__ == "__main__":
    if(len(sys.argv)==1):
        print("Usage: python3 ./setup  [ build, clean, up, down ]")
    elif len(sys.argv)==2:
        if(sys.argv[1]=="build"):
            build()
        elif sys.argv[1]=='clean':
            clean()
        elif sys.argv[1]=='up':
            up()
        elif sys.argv[1]=='down':
            down()
        else:
            print("Usage: python3 ./setup  [ build, clean, up, down ]")
    else:
        print("Usage: python3 ./setup  [ build, clean, up, down ]")
