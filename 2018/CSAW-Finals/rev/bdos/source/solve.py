#!/usr/bin/env python3

with open('bdos/script') as fp:
    script = fp.read()
realscript = '\n'.join(script.splitlines()[3:])
all_words = set(realscript.split())
word_a_map = {}
word_a_zero = None
for word_a in all_words:
    with open('bdos/words/' + word_a) as fp:
        word_a_txt = fp.read()
    if word_a_zero == word_a:
        continue
    word_b = word_a_txt.split()[2]
    word_a_map[word_a] = word_b
    if word_a_zero is None:
        word_a_zero = word_a_txt.split()[4]

word_b_map = {}
for word_b in word_a_map.values():
    with open('bdos/words/' + word_b) as fp:
        word_b_txt = fp.read()
    if word_b_txt.count('\n') == 2:
        continue
    word_ba = word_b_txt.split()[-6][1:]
    word_b_map[word_b] = word_ba

word_ba_map = {}
word_ba_bias = None
i = 0
word_ba_start = next(iter(word_b_map.values()))
word_ba = word_ba_start
while True:
    word_ba_map[word_ba] = i
    with open('bdos/words/' + word_ba) as fp:
        word_ba_txt = fp.read()
    if word_ba_txt.count('\n') == 2:
        word_ba_bias = i
        word_ba = word_ba_txt.split()[-4]
    else:
        word_ba = word_ba_txt.split()[-6]

    i += 1
    if word_ba == word_ba_start:
        break

base = i
words_map = {word_a: (word_ba_map[word_b_map[word_a_map[word_a]]] - word_ba_bias) % base for word_a in word_a_map}
words_map[word_a_zero] = 0
numbers_map = dict((y, x) for x, y in words_map.items())

final_sum = 0
for line in realscript.splitlines():
    for idx, word in enumerate(line.split()):
        final_sum += words_map[word] * base**idx

decomposition = []
while final_sum:
    final_sum, digit = divmod(final_sum, base)
    decomposition.append(digit)

final_text = '\n'.join(numbers_map[digit] for digit in decomposition) + '\n'
import hashlib
h = hashlib.sha512()
h.update(final_text.encode())
import os
os.system('python2 $(grep -lr python bdos/words) %s' % h.hexdigest())
