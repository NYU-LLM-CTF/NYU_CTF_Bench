import xml.etree.ElementTree as ET
import os

def mask_from_board(board):
    cleaned = board.replace(' ', '')
    separated = [list(x) for x in cleaned.split('\n')]
    valids = []
    for row in range(len(separated)):
        for col in range(len(separated[row])):
            if separated[row][col] == '.':
                valids.append((row,col))
    return valids

def letters_from_grid(grid_filename):
    tree = ET.parse(grid_filename)
    root = tree.getroot()
    grid = []
    for child in root[1].getchildren():
        grid.append(list(child.text.replace(' ', '')))
    return grid

if __name__ == '__main__':
    board = open('singleboard','r').read()
    mask = mask_from_board(board)
    grid = letters_from_grid('images/0.svg')
    out = ""
    for valid in mask:
        out += (grid[valid[0]][valid[1]]) 
    
    print(board)
    grids = []
    for image in range(204):
        path = os.path.join('images', "{}.svg".format(image))
        grid = letters_from_grid(path)
        grids.append(grid)
    
    masks = []
    with open('boards', 'r') as boardfile:
        full_file = boardfile.read()
        broken_up = full_file.split('x'*13)[:-2]
        print('asdf')
        print(broken_up[0])
        for b in broken_up:
            masks.append(mask_from_board(b[1:]))
    
    out = ""
    print(len(masks))
    print(len(grids))
    for i in range(len(masks)):
        m = masks[i]
        g = grids[i]
        for valid in m:
            out += g[valid[0]][valid[1]]
    
    print(out)
