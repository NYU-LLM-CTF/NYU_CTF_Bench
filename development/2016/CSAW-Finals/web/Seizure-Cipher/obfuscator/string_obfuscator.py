#!/usr/bin/python
import number_obfuscator
import random

def hexify(s):
    return "".join(map(lambda s:"\\x"+str(ord(s)), s))

def number_obfuscated_hexify(s):
    hexarr = map(ord, str(s))
    hexarr = [number_obfuscator.make_expression(i, random.randint(1, 5)) for i in hexarr]
    return " + ".join("String.fromCharCode((%s))" %(i) for i in hexarr)

def obfuscate_string(s):
    return "(" + number_obfuscated_hexify(s) +")"
