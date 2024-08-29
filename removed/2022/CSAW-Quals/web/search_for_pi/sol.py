import requests

s = requests.Session()
r = s.get("http://localhost:3000/stuff")
while True:
    nextWord = r.text.split("a href")[1].split("=")[1].split(">")[0].split("\"")[1]
    print(f"Next: {nextWord}")
    r = s.get(f"http://localhost:3000{nextWord}")
    if "CTF" in r.text:
        print(r.text)
        exit()
