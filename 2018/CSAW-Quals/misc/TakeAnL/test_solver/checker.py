def isL(n, tile):
    validX = False
    validY = False
    if len(tile) != 3:
        return False
    for point in tile:
        for x in range(2):
            if point[x] < 0 or point[x] >= pow(2, n):
                return False
    for i in range(3):
        for j in range(i + 1, 3):
            xDiff = abs(tile[i][0] - tile[j][0])
            yDiff = abs(tile[i][1] - tile[j][1])
            if xDiff == 1:
                validX = True
            if yDiff == 1:
                validY = True
            if xDiff > 1 or yDiff > 1 or xDiff + yDiff == 0:
                return False
    if validX and validY:
        return True
    return False


def checker(n, tiles, invalid):
    grid = [[0 for _ in range(pow(2, n))] for _ in range(pow(2, n))]
    for tile in tiles:
        # if not isL(n, tile):
        #     return False
        for point in tile:
            if grid[point[0]][point[1]] or grid[point[0]][point[1]] == invalid:
                return False
            grid[point[0]][point[1]] = 1
    for row in range(len(grid)):
        for column in range(len(grid[row])):
            if row == invalid[0] and column == invalid[1]:
                continue
            if not grid[row][column]:
                return False
    return True
