"""
generate.py

    Builds a no-std injectable executable
"""

import random
import subprocess

def main():
    source = """#define TWIST(a) ((a) + 0x28)

int main(void) {
    char final[] = {};
    int a = 201782; if (a == 16218) return 1;
    """

    with open("flag.txt", "r") as fd:
        flag = fd.read().strip()

    for pos, char in enumerate(flag):
        arand = random.randrange(0, 1929172)
        brand = random.randrange(0, 2819271)

        # no collisions
        assert(arand != brand)

        source += """
    final[{}] = TWIST('{}');
    a = {}; if (a == {}) return 1;
""".format(pos, char, arand, brand)

    source += """
    return 0;
}
    """

    print(source)

    # write finalized source to C file
    with open("generated.c", "w") as fd:
        fd.write(source)
    print("[*] Wrote source")

    # generated unoptimized source code for injection
    subprocess.call(["gcc", "-fno-stack-protector",
        "-fno-asynchronous-unwind-tables", "-O0",
        "generated.c", "-s", "-c", "-o", "generated.o"
    ])
    print("[*] Compiled source to object")

    # converting to nasm file
    subprocess.call(["objconv", "-fnasm", "generated.o", "generated.asm"])
    print("[*] Translated object to NASM")

    # cleanup for flat binary generation
    #subprocess.call("""sed -i "s/align=1//g ; s/[a-z]*execute//g ; s/: *function//g;  /default *rel/d" generated.asm""".split())
    #print("[*] Cleanup NASM file")

    #subprocess.call("nasm -f bin generated.asm".split())
    #print("[*] Generate flat binary file")

if __name__ == "__main__":
    main()
