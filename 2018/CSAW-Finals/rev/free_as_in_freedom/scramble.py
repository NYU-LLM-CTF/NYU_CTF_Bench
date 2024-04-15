import os
import sys
import random
import string

random.seed(int(sys.argv[1], 0))

def create_script():
    """
    Takes individual bytes of the flag (48 bytes) and copies them
    into random locations in a larger 256 array. The rest of the
    spaces are filled with random bytes:
    """
    idxs = range(256)
    random.shuffle(idxs)

    cmds = []
    cmds.append("f loc.hash = loc.flag+0x30")

    # Write flag bytes with random transformation
    cmds_inner = [ ]
    for i,j in enumerate(idxs[:48]):
        fil = ''.join(random.choice(string.ascii_uppercase + string.digits)
                for i in range(10))
        cmd  = [ "pc* 1@loc.flag+{}>/tmp/{}".format(i, fil) ]
        cmd += [ "s loc.hash+{}".format(j) ]
        cmd += [ ". /tmp/{}".format(fil) ]
        choice = random.randint(0, 100)
        if choice < 50:
            # inc/dec byte by small random constant
            sign = '-' if choice < 25 else '+'
            cmd += [ "w1{}{}".format(sign, random.randint(0, 10)) ]
        cmds_inner.append(";".join(cmd))

    # Add in some chaff commands to fill out the rest of the 256 spaces.
    idxs = sorted(idxs[48:])
    lst = idxs[0]
    consecutive_locs = [ ]
    consecutive_last = [ idxs[0] ]
    i = 1
    while i < len(idxs):
        if idxs[i] == lst + 1:
            consecutive_last.append(idxs[i])
        elif len(consecutive_last) != 0:
            consecutive_locs.append(consecutive_last)
            consecutive_last = [ idxs[i] ]
        lst = idxs[i]
        i += 1
    consecutive_locs.append(consecutive_last)
    for i in consecutive_locs:
        # 75% of the time write constant chaff
        # 25% of the time write random chaff
        if random.randint(0, 100) < 75:
            # write constant chaff; never changes between runs
            chaff = [ random.randint(0x20, 0x7e) for _ in range(i[-1] - i[0] + 1) ]
            cmds_inner.append("wx {}@loc.hash+{}".format(
                "".join(map(lambda x: "{:02x}".format(x), chaff)),
                i[0]))
        else:
            # write random chaff (random each time the script is run)
            cmds_inner.append("wr {}@loc.hash+{}".format(
                i[-1] - i[0] + 1, i[0]))

    random.shuffle(cmds_inner)
    cmds += cmds_inner
    cmds.append("px@loc.hash")
    return cmds


def pack(cmds):
    lines = [ ]
    lines.append("# usage: r2 -i welcome2.r2 -q flag.txt")
    lines.append("e io.cache = true")
    lines.append("f loc.flag = 0x2000")
    lines.append("wr 48@loc.flag")
    lines.append("w `psz`@loc.flag")

    # The commands will be NULL-delimited; we can use r2 to emit
    # an r2 script writing these bytes to the file
    cmds = "\x00".join(cmds)
    open("/tmp/a", "w").write(cmds)
    os.system("r2 -c \"pc* {}\" -q /tmp/a > /tmp/b".format(len(cmds)))
    lines += open("/tmp/b", "r").read().splitlines()

    # For some reason / doesn't work in r2 reliably... let's save
    # all the idx's as hit variables to iterate over
    lines.append("f hit0 = 0")
    idx = 1
    for i,j in enumerate(cmds):
        if j == '\x00':
            lines.append("f hit{} = {}".format(idx, i+1))
            idx += 1

    # write unpacker stub
    lines.append("(a,psz > /tmp/x,. /tmp/x)")
    lines.append(".(a) @@ hit*")

    return lines

cmds = create_script()
open("unpacked.r2", "w").write("\n".join(cmds))
open("welcome2.r2", "w").write("\n".join(pack(cmds)))
