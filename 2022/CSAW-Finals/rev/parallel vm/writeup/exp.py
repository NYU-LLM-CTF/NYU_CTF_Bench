from ctypes import *

def decrypt(v, k):
    v0, v1 = c_uint32(v[0]), c_uint32(v[1])
    delta = 0x9e3779b9 
    k0, k1, k2, k3 = k[0], k[1], k[2], k[3]

    total = c_uint32(delta * 32)
    for i in range(32):                       
        v1.value -= ((v0.value<<4) + k2) ^ (v0.value + total.value) ^ ((v0.value>>5) + k3) 
        v0.value -= ((v1.value<<4) + k0) ^ (v1.value + total.value) ^ ((v1.value>>5) + k1)  
        total.value -= delta

    return v0.value, v1.value   

from libnum import n2s

if __name__ == "__main__":
    value = [0xfab8d0f8, 0x9ac5ea91]
    key = [0x1, 0x5, 0x8, 0xf]
  
    res = decrypt(value, key)
    print("Decrypted data is : ", hex(res[0]), hex(res[1]))
    print("Flag is : %s"%(n2s(res[0])[::-1]+n2s(res[1])[::-1]).decode())
    #sl!c3Ye5