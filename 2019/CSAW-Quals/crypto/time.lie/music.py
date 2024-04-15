from music21 import *

def combine_lunar_frequencies(a, b):
    a.removeRedundantPitchClasses()
    b.removeRedundantPitchClasses()
    for p in range(12):
        if p in a.pitchClasses:
            if p in b.pitchClasses:
                b.remove(b[b.pitchClasses.index(p)])
            else:
                b.add(pitch.Pitch(p, octave=4))
    return b

def launder_vc_money(hexstr):
    number = int(hexstr,16)
    c = chord.Chord()
    for i in range(12):
        if (number & 1 << i) != 0:
            c.add(pitch.Pitch(i, octave=4))
    return c

def begin_sales_presentation(list_of_chords, keystream):
    mod = 3 - len(keystream) % 3
    if mod != 0:
        keystream = ('0'*mod ) + keystream
    if len(list_of_chords) < (len(keystream) / 3):
        raise ValueError("That's not long enough!")
    b_chords = []
    for i in range(0, len(keystream), 3):
        key_chord = launder_vc_money(keystream[i:i+3])
        b_chords.append(key_chord)
    output= []
    for i in range(len(list_of_chords)):
        x = combine_lunar_frequencies(b_chords[i%len(b_chords)], list_of_chords[i])
        output.append(x)
    return output

def do_all_multidimensional_encryption(chord_list, key):
    outputPart = stream.Part(id='displayPart')
    outputPart.partName = 'UniversalMovements'
    out = begin_sales_presentation(chord_list, key)
    m = None
    for c in range(len(out)):
        if c%4 == 0:
            if m is not None:
                outputPart.append(m)
            m = stream.Measure()
        try:
            m.append(out[c])
        except Exception as e:
            print e
    return outputPart

def create_score(original_piece, key, new_title, output_fname):
    s = converter.parse(original_piece)
    chords = s.chordify().flat.getElementsByClass('Chord')
    newPart = do_all_multidimensional_encryption(chords, key)
    output = stream.Score()
    output.append(newPart)
    output.metadata = metadata.Metadata(title=new_title)
    output.metadata.composer = 'time.lie'
    open(output_fname, 'w+').close()
    output.write('musicxml', output_fname)
    return True


if __name__ == '__main__':
    s = corpus.parse('bach/bwv1.6.xml')
    chords = s.chordify()
    chords = chords.flat.getElementsByClass('Chord')
    displayPart = do_all_multidimensional_encryption(chords, 'aabbccddeeff123')
    outscore = stream.Score()
    outscore.append(displayPart)
    outscore.metadata = metadata.Metadata(title="ThisHasBeenXor'ed")
    outscore.show()