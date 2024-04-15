from z3 import *

def main():
    buf = [102, 110, 101, 103, 131, 114, 59, 114, 128, 95, 69, 113, 95, 134, 138, 74, 112, 114, 51, 138, 95, 57, 142, 95, 130, 70, 132, 134, 75, 150, 95, 77, 110, 159, 56, 58, 52, 54, 56, 58, 68, 70, 129]

    s = Solver()
    guess_len = 43
    chrs = [BitVec(f'chrs_{i}', 8) for i in range(guess_len)]
    ax = []
    for i in range(guess_len):
        ax.append((i ^ chrs[i])+i == buf[i])
    s.add(And(ax))

    if s.check() == sat:
        m = s.model()
        l = list(m.evaluate(chrs[i]) for i in range(len(chrs)))
        print("".join(map(lambda x: chr(x.as_long()), l)))
    else:
        print("Unsat")

main()
