"""
1) SOLVER FROM: https://payatu.com/blog/csaw-ctf-finals-2018-insayne-rew-250-writeup

2) arr_0x604088 variable is confirmed to be locatable from the decompiled binary, with name data_604088 when using binary ninja

"""

from Crypto.Util.number import isPrime
mod = 0x8ac7230489e80000

def fib(n, _cache={}):
    '''efficiently memoized recursive function, returns a Fibonacci number'''
    if n in _cache:
        return _cache[n]
    elif n > 1:
        return _cache.setdefault(n, fib(n-1) + fib(n-2))
    return n

'''
[0x00604088]> pxq 62*8
'''
flag = ''

arr_0x604088 = [0x0000000000000069, 0x000000000000006b, 0x0000000000000024, 0x000000000000002d, 0x000000000000003f, 0x0000000000000085, 0x000000000000065c, 0x0000000000001032, 0x0000000000006fd1, 0x000000000007d8dc, 0x0000000000148aae, 0x0000000001709e43, 0x0000000009de8d4d, 0x0000000019d699c3, 0x00000000b119248d, 0x0000000c69e60a04, 0x000000dec113965e, 0x000002472d96a972, 0x000028e0b4bf2bb9, 0x0001182e2989cebd, 0x0002dd8587da6e47, 0x00336a82d89c9330, 0x016069317e428cf6, 0x18b3c1d91e77de9d, 0x3240e2d181223220, 0x2baf6373dbe838b6, 0x073950ec18c5313e, 0x41838009bc58e07c, 0x4fc6cdc83cbb455a, 0x19568517131788a2, 0x030f7bd5f7e4a029, 0x67f7e718178ec0e7, 0x014b63ebbe1f7469, 0x6fd5280bc8cbb8ba, 0x493f53f1269e0b1c, 0x3f94756512a1ef8c, 0x374f52aaa0d0553d, 0x6354887f00940f76, 0x7c63c3b79148c8f9, 0x1a72a23c580389e4, 0x4a1d5e7d8b26e807, 0x68824ddf2c14b0be, 0x0988b22957af8bde, 0x005a365e21fdb4b9, 0x70febf7992c701ec, 0x45e80772963b72e3, 0x5b656a15e45ad6b4, 0x4d858b58f9cec52f, 0x4b85e107e3108430, 0x24c6b1482aff1e90, 0x43a3e729aec76a88, 0x1fc747c217b50012, 0x4af69f78486233fe, 0x1a5964ce9b71f58d, 0x6cb1150f7bf8ab6f, 0x7dfd4f0d1b421262, 0x4d736c985a149eca, 0x762bc1ac0419dd9e, 0x39deb71e84b24129, 0x80072969eea6cc22, 0x5ad24c5e14feb5a9, 0x454e2d665f785a38]
idx = 0
i = 0

while True:
    if idx == 62:
        break
    if isPrime(i):
        flag += chr((arr_0x604088[idx] ^ (fib(i) %  mod)) % 0xff)
        idx += 1
    i += 1

print (flag)
