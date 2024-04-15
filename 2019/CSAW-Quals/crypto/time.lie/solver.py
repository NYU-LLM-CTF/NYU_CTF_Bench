import requests
import re
from xml.etree import ElementTree
from music21 import *
import pickle
from sage.all import *

def get_new_sheet():
    # s = corpus.parse('mozart/k156/movement1.xml')
    # s = corpus.parse('bach/bwv65.2.xml')
    # output_fname = 'k151.xml'
    # output_fname='bwv65.xml'
    s = corpus.parse('bach/bwv1.6.mxl')
    output_fname = 'bwv16.xml'
    open(output_fname, 'w+').close()
    s.write('musicxml', output_fname)

def get_seed_from_base(addr, fname, index):
    target = addr + '/musicin'
    r = requests.post(target, files={'file':('file.xml', open(fname,'rb'))})
    new_filename = str('/'.join(r.url.split('/')[-2:]))

    r = requests.get(addr+'/'+new_filename)
    with open('solve/'+str(index)+'.xml', 'w') as out:
        out.write(r.text)
    return 'solve/'+str(index)+'.xml'

def xor_chords(a, b):
    a.removeRedundantPitchClasses()
    b.removeRedundantPitchClasses()
    for p in range(12):
        if p in a.pitchClasses:
            if p in b.pitchClasses:
                b.remove(b[b.pitchClasses.index(p)])
            else:
                b.add(pitch.Pitch(p, octave=4))
    return b

def chord_to_nybbles(chord):
    l = chord.pitchClasses
    l = sorted(l)
    num = 0
    for i in l:
        num |= (1 << i)
    num = hex(num).replace('0x','')
    num = '0'*(3-len(num)) + num
    return num

def do_xor(fname, origfname):
    s = converter.parse(fname)    
    title = s.metadata.title
    # chords = s.chordify().flat.getElementsByClass('Chord')
    chords = s.flat.getElementsByClass('Chord')
    chords = list(chords)
    # chords.pop(13)
    t = converter.parse(origfname)
    tchords = t.chordify().flat.getElementsByClass('Chord')
    res = []
    i = 0
    for a, b in zip(chords,tchords):
        i+=1
        res.append(xor_chords(a,b))
    fin = []
    for r in res[1:]:
        fin.append(chord_to_nybbles(r))
    return (title, ''.join(fin))

def rederive(shares, fieldspace):
    field = GF(fieldspace)
    ring = field['x']
    fixed = []
    for x, y in shares:
        x_ = field(x)
        y_ = field(y)
        fixed.append((x_,y_))
    polynomial = ring.lagrange_polynomial(fixed)
    return polynomial

if __name__ == '__main__':
    # get_new_sheet()
    seeds = []
    for i in range(20):
        seeds.append(do_xor(get_seed_from_base('http://127.0.0.1:1234','bwv16.xml',i), 'bwv16.xml'))
    #pickle.dump(seeds, open('xxxx.pickle','wb'))

    # newseeds = seeds + pickle.load(open('seeds.pickle','rb'))

    # a = pickle.load(open('seeds.pickle','rb'))
    # b = pickle.load(open('newseeds.pickle', 'rb'))
    # seeds = a+b
    fixed = []
    for s in seeds:
        num = s[1].split('000')[0]
        if len(num) == 54:
            num = int(num,16)
            fixed.append((int(s[0]), num))
    print len(fixed)
    for f in fixed:
        print f
    
    print rederive(fixed, 101109149181191199401409419449461491499601619641661691809811881911)