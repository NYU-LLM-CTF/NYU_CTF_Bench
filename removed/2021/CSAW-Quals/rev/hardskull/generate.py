flag = 'flag{h4rdsk3ll_is_s0_much_fun_to_rev3rs3_lol_<3!!}'
#            ....    ....    ....    ....----....----....
def tostr(num):
    series = []
    for b in bin(num)[2:][::-1]:
        series.append('b' + b)
    series.append('bz')
    return ' $ '.join(series)

xornum = tostr(0xdeadbeef)
print(f'#define XORKEY ({xornum})')

res = '('
for i in range(5, len(flag) - 1, 4):
    x = 0
    for c in flag[i:i+4]:
        x *= 257
        x += ord(c)
    num = tostr(x ^ 0xdeadbeef)
    print(f'#define CHK_{i} ({num})')
    res += f'CHK_{i} @. '
res += 'Nil)'
print(res)
