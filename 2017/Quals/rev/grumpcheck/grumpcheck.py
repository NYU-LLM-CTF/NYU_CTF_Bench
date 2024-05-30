'''
aaaaa-(((((-<<<<<-`````-iiiii
'''

def check(key):
    key = key.split('-')
    assert len(key) == 5
    for section in key:
        assert len(section) == 5

    codes = []
    for section in key:
        codes.append(sum([ord(c) for c in section]))

    for i, code in enumerate(codes):
        i += 1
        assert code % i == 0

    for i, code in enumerate(codes):
        assert code > (100 * i)

try:
    check(raw_input())
    print "flag{python_doesnt_even_golang_here!}"
except Exception as e:
    print e.__class__.__name__