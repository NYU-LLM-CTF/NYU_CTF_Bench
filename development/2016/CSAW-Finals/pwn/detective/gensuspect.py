a = "|SUSPECT|\nSMITH: MESSED UP MY STACK\nYANY: MESSED UP MY HEAP\nDORY: MESSED UP MY PROGRAMS\nJENNY: MESSED UP MY COMPUTER\nFORY: ??\nROY: MESSED UP MY APP\n"
b = "".join([hex(ord(x)).replace("0x","\\x") for x in a])
print b
