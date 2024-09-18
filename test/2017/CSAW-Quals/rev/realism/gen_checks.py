from __future__ import print_function

def get_table(s, sub_vals):
    table = []

    for m1, m2 in zip(range(0, 8), range(8, 16)):
	s_i = [ord(c) if i not in (m1, m2) else 0 for i, c in enumerate(s)]
        subs = [abs(a - b) for a, b in zip(s_i, sub_vals)]
	lo, hi = sum(subs[:8]), sum(subs[8:])
        table.append((lo, hi))
	# update subs table
	sub_vals = [0 for _ in range(16)]
        sub_vals[0] = lo & 0xFF
        sub_vals[1] = (lo & 0xFF00) >> 8

        sub_vals[8] = hi & 0xFF
        sub_vals[9] = (hi & 0xFF00) >> 8
    return table

def shuf(s):
    a, b, c, d = s[0:4], s[4:8], s[8:12], s[12:16]
    return c + d + b + a

flag = '{4r3alz_m0d3_y0}'
# first 0x10 bytes of binary
sub_table = [0xb8, 0x13, 0x00, 0xcd, 0x10, 0x0f, 0x20, 0xc0,
               0x83, 0xe0, 0xfb, 0x83, 0xc8, 0x02, 0x0f, 0x22]
#table = get_table(shuf(flag), sub_table)
table = get_table(shuf(flag), sub_table)

# gen asm
print('sums:')
for i, (lo, hi) in reversed(list(enumerate(table))):
    print('dd 0x{:x} ; {}'.format((lo << 16) | hi, i))

print('-'*80)

# gen python
print('split_results = [')
print('    # H    L')
for lo, hi in reversed(list(table)):
    print('    (0x{:x}, 0x{:x}),'.format(hi, lo))
print(']')
