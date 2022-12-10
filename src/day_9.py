with open('data/day_9.txt') as f:
    data = f.read()

import io

def parse(pre=False):
    val = 1
    if pre:
        yield val
    for line in io.StringIO(data):
        if line.startswith('add'):
            yield val
            val += int(line.strip().split()[1])
            yield val
        elif line.startswith('noop'):
            yield val

# star1
valid = {x-1 for x in (20, 60, 100, 140, 180, 220)}
t = [(i+1)*x for i,x in enumerate(parse(True)) if i in valid]
print(sum(t))

# star2
def in_sprite(clock, reg):
    return (reg-1)%40 <= clock%40 <= (reg+1)%40
def form(s):
    return '#' if s else '.'
print()
for i,x in enumerate(parse(True)):
    print(form(in_sprite(i, x)), end='')
    if (i+1)%40==0:
        print()
