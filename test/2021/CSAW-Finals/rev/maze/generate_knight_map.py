# the map looks like this:

# 0: wall
# 1: ordinary block
# *: start

# 000000000000
# 000000000000
# 001111111100
# 001111111100
# 001111111100
# 001111111100
# 00111*111100
# 001111111100
# 001111111100
# 001111111100
# 000000000000
# 000000000000


f = open('map.asm', 'w')
N = 8
M = 2

x = 0
for i in range(M):
    for _ in range(N + 2 * M):
        f.write('wall\n')

for i in range(N):
    for _ in range(M):
        f.write('wall\n')

    for _ in range(N):
        x += 1
        # set the entry at near the center of the map
        if x == 36:
            f.write('maze_entry:\n')

        f.write('ordinary_block\n')

    for _ in range(M):
        f.write('wall\n')

for i in range(M):
    for _ in range(N + 2 * M):
        f.write('wall\n')\

f.close()
