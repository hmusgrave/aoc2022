with open('data/day_7.txt') as f:
    data = f.read()

import io
from math import inf

grid = [list(map(int, line.strip())) for line in io.StringIO(data) if line]

def vis(slc):
    i = -inf
    for j,z in enumerate(slc):
        if z > i:
            yield j
            i = z

def row_vis(grid, row):
    left_vis = list(vis(grid[row]))
    right_vis = list(vis(grid[row][::-1]))

    left = {(row,i) for i in left_vis}
    right = {(row,(len(grid[0])-1-i)) for i in right_vis}
    return left.union(right)

def col_vis(gridt, col):
    return [(y,x) for x,y in row_vis(gridt, col)]

def transpose(grid):
    return list(zip(*grid))

def all_row_vis(grid):
    t = set()
    for i in range(len(grid)):
        t = t.union(row_vis(grid, i))
    return t

def all_col_vis(grid):
    grid = transpose(grid)
    t = set()
    for i in range(len(grid[0])):
        t = t.union(col_vis(grid, i))
    return t

def all_vis(grid):
    return all_row_vis(grid).union(all_col_vis(grid))

# star 1
print(len(all_vis(grid)))

def score(i, j):
    m = 1
    t = 0
    for k in range(i-1, -1, -1):
        t += 1
        if grid[k][j] >= grid[i][j]:
            break
    m *= t
    t = 0
    for k in range(i+1, len(grid)):
        t += 1
        if grid[k][j] >= grid[i][j]:
            break
    m *= t
    t = 0
    for k in range(j-1, -1, -1):
        t += 1
        if grid[i][k] >= grid[i][j]:
            break
    m *= t
    t = 0
    for k in range(j+1, len(grid[0])):
        t += 1
        if grid[i][k] >= grid[i][j]:
            break
    m *= t
    return m

z = max(score(i,j) for i in range(len(grid)) for j in range(len(grid[0])))
print(z)
