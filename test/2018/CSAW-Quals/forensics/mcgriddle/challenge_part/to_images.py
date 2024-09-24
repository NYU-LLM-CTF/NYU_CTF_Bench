import svgwrite
"""
dwg = svgwrite.Drawing('test.svg', (100,100))
paragraph = dwg.add(dwg.g(font_size = 14))
paragraph.add(dwg.text("TEST TEXT", (12,20)))
paragraph.add(dwg.text("TEST TEXT", (12,30)))
paragraph.add(dwg.text("TEST TEXT", (12,40)))
paragraph.add(dwg.text("TEST TEXT", (12,50)))
paragraph.add(dwg.text("TEST TEXT", (12,60)))
paragraph.add(dwg.text("TEST TEXT", (12,70)))
paragraph.add(dwg.text("TEST TEXT", (12,80)))
paragraph.add(dwg.text("TEST TEXT", (12,90)))
dwg.save()
"""
def break_boards(infile):
    boards = []
    with open(infile, 'r') as boardfile:
        boards = [b.split('\n') for b in boardfile.read().split('\n\n') if b != '']

    return boards

def gen_image(board, filename):
    dwg = svgwrite.Drawing(filename,(100,100))
    paragraph = dwg.add(dwg.g(font_size = 14))
    i=0
    for line in board:
        if line != '':
            paragraph.add(dwg.text(line, (4, (20+i*10))))
            i+=1
    dwg.save()


if __name__ == '__main__':
    boards = break_boards('gboards')

    index = 0
    for board in boards:
        filename = 'images/{}.svg'.format(str(index))
        print(filename)
        gen_image(board,filename)
        index += 1
