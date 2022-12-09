import io

with open('data/day_8.txt') as f:
    data = f.read()

moves = {
    'L': (-1, 0),
    'R': (1, 0),
    'D': (0, -1),
    'U': (0, 1),
}

def parse_line(line):
    key, n = line.strip().split()
    for _ in range(int(n)):
        yield moves[key]

def parse():
    for line in io.StringIO(data):
        if line.strip():
            yield from parse_line(line)

def unit(z):
    if z == 0:
        return z
    return z // abs(z)

def move_tail(head, tail):
    (a, b), (x, y) = head, tail
    if max(abs(a-x), abs(b-y)) <= 1:
        return tail
    return x+unit(a-x), y+unit(b-y)

def move_head(head, delta):
    (a, b), (x, y) = head, delta
    return a+x, b+y

def move_all(moves, n):
    pos = [(0,0) for _ in range(n)]
    positions = {(0,0)}
    for m in moves:
        pos[0] = move_head(pos[0], m)
        for i,(a,b) in enumerate(zip(pos, pos[1:]), 1):
            pos[i] = move_tail(a, b)
        positions.add(pos[-1])
    return len(positions)

# star 1
print(move_all(parse(), 2))

# star 2
print(move_all(parse(), 10))
