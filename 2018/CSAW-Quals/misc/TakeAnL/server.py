#!/usr/bin/env python2

import sys
from random import randint
from checker import checker, isL
import math

flag = 'flag{m@n_that_was_sup3r_hard_i_sh0uld_have_just_taken_the_L}'


class Unbuffered(object):
   def __init__(self, stream):
       self.stream = stream
   def write(self, data):
       self.stream.write(data)
       self.stream.flush()
   def writelines(self, datas):
       self.stream.writelines(datas)
       self.stream.flush()
   def __getattr__(self, attr):
       return getattr(self.stream, attr)

sys.stdout = Unbuffered(sys.stdout)


class InvalidInput(Exception):
    pass


def greeting(invalid):
    print 'each L shaped block should be sent in its '
    print 'own line in a comma separated list'
    print 'eg: (a,b),(a,c),(d,c)'
    print
    print 'grid dimensions 64x64'
    print 'marked block: ' + str(invalid)

def parse_point(line):
    try:
        line = line.replace(')', '')
        line = line.replace('(', '')
        line = line.replace('[', '')
        line = line.replace(']', '')
        a, b = (int(i) for i in line.replace(' ', '').split(','))
        return a, b
    except:
        raise InvalidInput()
        sys.exit(1)

def parse(line):
    try:
        return [parse_point(i) for i in line.replace(' ', '').split('),(')]
    except:
        raise InvalidInput()
        sys.exit(1)

def main():
    num_blocks = 1365
    invalid = (randint(0, 63), randint(0, 63))
    greeting(invalid)
    tiles = []
    for _ in range(num_blocks):
        try:
            point = parse(str(raw_input()))
            if not isL(6, point):
                raise InvalidInput()
            tiles.append(point)
        except:
            print 'invalid formatting / input'
            sys.exit(1)
    if checker(6, tiles, invalid):
        print flag
    else:
        print 'sorry thats not quite right'



if __name__ == "__main__":
    main()
