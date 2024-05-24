import os
import string
flag = ["A" for i in xrange(30)]
for i, j in enumerate("flag{jk_there_was_"):
    flag[i] = j
flag[29] = '}'
for j in xrange(18,29):
    cc = []
    for i in string.lowercase+"_":
        flag[j] = i
        ff = open("ff", "w")
        ff.write("".join(flag))
        ff.close()
        os.system("~/tools/pin/pin -t ~/tools/pin/source/tools/ManualExamples/obj-intel64/inscount0.so -- ./mystery_boi < ff")
        ic = open("inscount.out")
        ic = int(ic.read().split()[1])
        cc.append((i, ic))
        print (i, ic)
    yy = sorted(cc, key=lambda tup: tup[1], reverse=True)
    flag[j] = yy[0][0]
    print "".join(flag)