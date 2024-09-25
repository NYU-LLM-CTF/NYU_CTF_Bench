#!/usr/bin/python3
import random

from slimit.parser import Parser
from slimit.visitors import nodevisitor
from slimit import ast
from slimit import minify

import boolean_obfuscator
import number_obfuscator
import string_obfuscator

with open("asdf.js", "r") as FILE:
    lol = FILE.read()

#newtonsqrt = "function adsf(n){var asdf = 1;for (var i = 0; i < 100; i++){var asdf = 1/2*(n/asdf + asdf);}}"
#test = "if (10) { print('asdf'); } else { print('fdsa');} test(); Math.test(); Math.sqrt(2)"
#test = "print('true')"
#test = "print(true); print(false);"

parser = Parser()
def lvl1(src):
    tree = parser.parse(src)
    for node in nodevisitor.visit(tree):

        #: Fuck up all of your constants
        if isinstance(node, ast.Boolean):
            node.value = str(boolean_obfuscator.make_expression(node.value.lower() == 'true', random.randint(5,20)))
        if isinstance(node, ast.Number):
            node.value = str(number_obfuscator.make_expression(int(node.value), random.randint(2, 8)))
        if isinstance(node, ast.String):
            node.value = string_obfuscator.obfuscate_string(str(node.value[1:-1]))
    return tree.to_ecma() # print awesome javascript :)

def lvl2(src):
    tree = parser.parse(src)
    for node in nodevisitor.visit(tree):
        pass

#        if isinstance(node, ast.FunctionCall):
            #: Builtin square root? Nah fam thats for lightweights
#            if isinstance(node, ast.FunctionCall) and not isinstance(node.identifier, ast.Identifier): 
#                if node.identifier.identifier.value == "sqrt":
#                    pass
##                    node.identifier = ast.Identifier(lvl1(newtonsqrt))
#
    return tree.to_ecma() # print awesome javascript :)

def fuck_my_shit_up(src):
    lvls = [lvl1, lvl2]
    for lvl in lvls:
        src = lvl(src)
    return src

test = lvl1(lol)

with open("lol.js", "w") as FILE:
    FILE.write(test)#minify(test, mangle=True))
