#!/usr/bin/env python3

import hashlib

'''
                    a
                    |
    b---------------c---------------d
    |               |               |
e---f---g       h---i---j       k---l---m
|   |   |       |   |   |       |   |   |
n   o   p       q   r   s       t   u   v
                                Laura!... Bazooms!                                                                                                                        
                                98767cec58ce4cdb6181ff97710bef2ef2684dbe5c3f9b8f847d2a4d3c1540f0    
                                    WHOA, MAMA!
                                    d3776e045781f2a916b1eb6ff941fed6087d2f6bc02ad130fae6b9cbbe57b2e6    
                                        Loving you is like trying to touch a star. You know you'll never reach it, but you have to keep trying.
                                        f99b946aa21aa9d953063e5ef55340e9e5e36072f1c16e6e75b892c640c03095

                I have a lot of personal experience in first aid. I got a nosebleed at birth. My doctor slapped the wrong end.                                                                                                       
                001c16971dfc3b2737e3f35ddd53e6282e49b067ffd4738586bc000ba340af53    
                    [Pointing to the floor] Him. And him. And... OOHHH, and him!
                    c3eca993efb6567482a64337e0bf9eae68d849fd8f554270d6599a3a234f6a5a    
                        Because, I love you... love you... love you!
                        5b0e8855a94c2e7a0da5bae7c67ad0351fd4a7ded732042d55ab7608bda4a90a

[drinking spiked punch] What is this? Mango?                                                                                        
1d564f006a3705ff049aa756e46db2efb631980277f1532861ab3fb6c3213b7a    
    I just called my uncle at the Pentagon. Colonel Dirk Urkel!
    de9f61229a0795afb93773f7d8052d830e14036ebd81015e9be5c113f91160f2    
        Practice. Fortunately, when I was young I had no friends.
        1b3140105f16f1c061d870abeaa9b03690a35ebad83945198a1050839ff63e48
'''

# https://www.imdb.com/title/tt0096579/quotes/?item=qt0237571#
quotes = [
    "[drinking spiked punch] What is this? Mango?",
    # n = '1d564f006a3705ff049aa756e46db2efb631980277f1532861ab3fb6c3213b7a'
    "I just called my uncle at the Pentagon. Colonel Dirk Urkel!",
    # o = 'de9f61229a0795afb93773f7d8052d830e14036ebd81015e9be5c113f91160f2'
    "Practice. Fortunately, when I was young I had no friends.",
    # p = '1b3140105f16f1c061d870abeaa9b03690a35ebad83945198a1050839ff63e48'

    "I have a lot of personal experience in first aid. I got a nosebleed at birth. My doctor slapped the wrong end.",
    # q = '001c16971dfc3b2737e3f35ddd53e6282e49b067ffd4738586bc000ba340af53'
    "[Pointing to the floor] Him. And him. And... OOHHH, and him!",
    # r = 'c3eca993efb6567482a64337e0bf9eae68d849fd8f554270d6599a3a234f6a5a'
    "Because, I love you... love you... love you!",
    # s = '5b0e8855a94c2e7a0da5bae7c67ad0351fd4a7ded732042d55ab7608bda4a90a'

    "Laura!... Bazooms!",
    # t = '98767cec58ce4cdb6181ff97710bef2ef2684dbe5c3f9b8f847d2a4d3c1540f0'
    "WHOA, MAMA!",
    # u = 'd3776e045781f2a916b1eb6ff941fed6087d2f6bc02ad130fae6b9cbbe57b2e6'
    "I hurt myself. Can you carry me home?"
    # v = 'f99b946aa21aa9d953063e5ef55340e9e5e36072f1c16e6e75b892c640c03095'
]

def hash_line(line: str) -> str:
    return hashlib.sha256(line.encode()).hexdigest().encode()

def get_leaf_nodes(quotes: list) -> list: 
    return [ hash_line(line) for line in quotes ]

def hash_children(one: str = ''.encode(), two: str = ''.encode(), three: str = ''.encode()) -> str:
    children_hash = one + two + three

    return hashlib.sha256(children_hash).hexdigest().encode()

def get_root(nodes: list) -> str:
    n, o, p = nodes[0], nodes[1], nodes[2]
    e, f, g = hash_children(n), hash_children(o), hash_children(p)
    b = hash_children(e, f, g)

    q, r, s = nodes[3], nodes[4], nodes[5]
    h, i, j = hash_children(q), hash_children(r), hash_children(s)
    c = hash_children(h, i, j)

    t, u, v = nodes[6], nodes[7], nodes[8]
    k, l, m = hash_children(t), hash_children(u), hash_children(v)
    d = hash_children(k, l, m)

    return hash_children(b, c, d).decode()

leaf_nodes = get_leaf_nodes(quotes)
merkel_root = get_root(leaf_nodes)
print(merkel_root)
