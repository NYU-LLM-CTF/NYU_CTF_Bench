#!/usr/bin/env python3

import os
import sys
import random
import string
import hashlib

if len(sys.argv) != 4:
    print('usage: generate.py text outdir flag')
    sys.exit(1)

def rmch(w):
    valid = set(string.ascii_uppercase + ' \n\t')
    return ''.join(char for char in w if char in valid)

bee_text = rmch(open(sys.argv[1]).read().upper())
outdir = sys.argv[2]
flag = sys.argv[3]
random.seed(flag)

bee_words_all = bee_text.split()
bee_words = set(bee_words_all[1:])
A_start = bee_words_all[0]
assert A_start not in bee_words
A_words = list(bee_words)
A_words.sort()
random.shuffle(A_words)
base = len(A_words)
words_map = {word: idx for idx, word in enumerate(A_words)}

final_sum = 0
for line in bee_text.splitlines()[1:]:
    for idx, word in enumerate(line.split()):
        final_sum += words_map[word] * base**idx

decomposition = []
while final_sum:
    final_sum, digit = divmod(final_sum, base)
    decomposition.append(digit)

final_text = '\n'.join(A_words[digit] for digit in decomposition) + '\n'
h = hashlib.sha512()
h.update(final_text.encode())
final_hash = h.digest()
enc_flag = bytes(c1 ^ c2 for c1, c2 in zip(final_hash, flag.encode())).hex()

other_words = {wword.upper() for wword in open('/usr/share/dict/words').read().split() if all(c in string.ascii_letters for c in wword)}
other_words -= bee_words
other_words -= {A_start}
other_words = list(other_words)
other_words.sort()
other_words = other_words[:int(len(other_words) * 0.2)]
random.shuffle(other_words)

def pop(n=0):
    global other_words
    if n == 0:
        return other_words.pop()
    other_words, out = other_words[:-n], other_words[-n:]
    return out

os.mkdir(outdir)
os.mkdir(os.path.join(outdir, 'words'))

def dump(binary, data):
    path = os.path.join(outdir, 'words', binary)
    with open(path, 'w') as fp_:
        fp_.write(data)
    os.chmod(path, 0o755)

B_start = pop()
B_words = pop(base)
BA_words = pop(base)
BB_words = pop(base)
C_start, C_end, CA_zero = pop(3)
C_words = pop(base)
bcmd, ccmd, trigger = pop(3)
ZEROS = pop()

dump(A_start, f'''\
echo {B_start}
''')

dump(B_start, f'''\
echo {C_start}
''')

dump(C_start, f'''\
function {bcmd}() {{
	echo $@
}}
for f in {bcmd}*; do read x < <(/bin/bash "$f"); [[ -n "$x" ]] && $f $x; done
echo {C_end}
echo >"./{trigger}"
''')

dump(C_end, f'''\
owo="""
"
read x <"./{trigger}"
[[ -z "$x" ]] && /usr/bin/python2 $0 $(/bin/cat ./{ccmd}* | /usr/bin/sha512sum) 1>&2 && exit 1

for f in ./{ccmd}*; do echo {A_words[0]} >>"$f"; read x <"$f"; echo -n "$x "; echo {A_words[0]} >"$f"; done; echo
echo {B_start}
exit 0
"""

import sys
print 'you win!'
print ''.join(chr(ord(c1) ^ ord(c2)) for c1, c2 in zip('{enc_flag}'.decode('hex'), sys.argv[1].decode('hex')))
''')

dump(CA_zero, f'''\
echo 1 >"./{trigger}"
f=$(echo ./{ccmd} $@)
echo {A_words[0]} >>"$f"
read x <"$f"
echo {A_words[0]} >"$f"
$@
echo -n "$x "
''')

for value, word in enumerate(A_words):
    dump(word, f'''\
export {ZEROS}="${ZEROS} {B_words[0]}"
$@
''' if value == 0 else f'''\
echo ${ZEROS} {B_words[value]}
source {A_words[0]}
''')

for value, word in enumerate(B_words):
    dump(word, f'''\
export {ZEROS}="${ZEROS} {C_words[0]}"
$@
''' if value == 0 else f'''\
f="./{bcmd} ${ZEROS}"
echo -n >>"$f"
read x <"$f"
[[ -n "$x" ]] && /bin/bash "$f" {BB_words[value]} || echo '{BA_words[value]} $1; echo >"$0"' > "$f"
''')

for value, word in enumerate(BA_words):
    dump(word, f'''\
echo ${ZEROS} {C_words[0]} {C_words[1]}
[[ -n "$1" ]] && {BA_words[1]} $($1) || true
''' if value == 0 else f'''\
[[ -n "$1" ]] && {BA_words[(value + 1) % base]} $($1) || echo ${ZEROS} {C_words[value]}
''')

for value, word in enumerate(BB_words):
    dump(word, '\n' if value <= 1 else f'echo {BB_words[value-1]}\n')

for value, word in enumerate(C_words):
    dump(word, f'''\
export {ZEROS}="{CA_zero} ${ZEROS}"
$@
''' if value == 0 else f'''\
f=$(echo ./{ccmd} ${ZEROS})
echo {A_words[0]} >>"$f"
read x <"$f"
[[ "$x" != "{A_words[0]}" ]] && {CA_zero} ${ZEROS} && echo
echo {A_words[value]} >"$f"
source {C_words[0]}
''')

with open(os.path.join(outdir, 'script'), 'w') as fp:
    fp.write('#!/bin/bash -e\n\n')
    fp.write(bee_text)
with open(os.path.join(outdir, 'chal'), 'w') as fp:
    fp.write('''\
#!/bin/bash

cd $(dirname $(realpath $0))
export PATH=./words
/bin/bash -e ./script >> ./script
''')
os.chmod(os.path.join(outdir, 'chal'), 0o755)
