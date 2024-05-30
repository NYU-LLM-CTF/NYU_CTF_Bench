from checker import checker
import random
from pwn import *

n = 6

SERVER_ADDRESS = 'misc.chal.csaw.io'
PORT = 9000


def solver_helper(length, corner, direction, invalid):
    if corner[0] < 0 or corner[1] < 0:
        return
    if length == 2:
        tile = []
        for x in range(2):
            for y in range(2):
                xpos = corner[0] + direction[0] * x
                ypos = corner[1] + direction[1] * y
                if xpos == invalid[0] and ypos == invalid[1]:
                    continue
                tile.append((xpos, ypos))
        return [tile]
    new_l = length // 2
    offsetX = new_l * direction[0]
    offsetY = new_l * direction[1]
    if direction[1] < 0:
        offsetY += 1
    if direction[0] < 0:
        offsetX += 1
    directions = [(-1, -1), (-1, 1), (1, -1), (1, 1)]
    options = [(corner[0] + offsetX - 1, corner[1] + offsetY - 1),
               (corner[0] + offsetX - 1, corner[1] + offsetY),
               (corner[0] + offsetX, corner[1] + offsetY - 1),
               (corner[0] + offsetX, corner[1] + offsetY)]
    fill_in = []
    invalids = []
    for i, option in enumerate(options):
        minX = False
        minY = False
        validX = False
        validY = False
        if direction[0] * invalid[0] >= direction[0] * corner[0]:
            minX = True
        if direction[1] * invalid[1] >= direction[1] * corner[1]:
            minY = True
        if directions[i][0] * invalid[0] >= directions[i][0] * option[0]:
            validX = True
        if directions[i][1] * invalid[1] >= directions[i][1] * option[1]:
            validY = True
        if validX and validY and minX and minY:
            invalids.append(invalid)
        else:
            invalids.append(option)
            fill_in.append(option)
    return (solver_helper(new_l, options[0], directions[0], invalids[0]) +
            solver_helper(new_l, options[1], directions[1], invalids[1]) +
            solver_helper(new_l, options[2], directions[2], invalids[2]) +
            solver_helper(new_l, options[3], directions[3], invalids[3]) +
            [fill_in])


def solver(n, invalid):
    return solver_helper(pow(2, n), (0, 0), (1, 1), invalid)


# def visualizer(n, tiles, invalid):
#     grid = [[0 for _ in range(pow(2, n))] for _ in range(pow(2, n))]
#     grid[invalid[0]][invalid[1]] = 2
#     for tile in tiles:
#         for point in tile:
#             grid[point[0]][point[1]] = 1
#     for row in range(len(grid)):
#         for column in range(len(grid[row])):
#             if grid[row][column] == 1:
#                 print('#', end='')
#             elif grid[row][column] == 2:
#                 print('X', end='')
#             else:
#                 print('O', end='')
#             print(' ', end='')
#         print('')

# context.log_level = 'debug'


def sendSolver():
    conn = remote(SERVER_ADDRESS, PORT)
    # conn = process('./server.py')
    print(conn.recvuntil('block: '))
    mark = eval(conn.recvline())
    print(mark)
    tiles = solver(6, mark)
    for tile in tiles:
        tile = str(tile)
        tile = tile[1:]
        tile = tile[:-1]
        conn.sendline(str(tile))
    conn.interactive()

# invalid = (random.randint(0, pow(2, n)), random.randint(0, pow(2, n)))
# print(invalid)
# visualizer(n, tiles, invalid)
# print(checker(n, tiles, invalid))


sendSolver()
