with open('data/day_6.txt') as f:
    data = f.read()

class Node:
    def __init__(self):
        self.children = []

import io
from collections import defaultdict

contents = defaultdict(list)
pwd = []
for line in io.StringIO(data):
    line = line.strip()
    if line.startswith('$'):
        if line[2:4] == 'cd':
            if line[5:7] == '..':
                pwd.pop()
            else:
                pwd.append(line[5:])
        else:
            continue
    else:
        if line[:3] == 'dir':
            continue
        key = tuple(pwd)
        contents[key].append(int(line.split()[0]))

def reify(contents):
    for k,v in contents.items():
        contents[k] = sum(v)

def merge_up(contents, n=None):
    if n == None:
        n = max(map(len, contents))
    if n == 0:  # TODO
        return
    for k,v in list(contents.items()):
        if len(k) == n:
            try:
                contents[tuple(k[:-1])] += v
            except:
                contents[tuple(k[:-1])] = v
    merge_up(contents, n-1)

reify(contents)
merge_up(contents)

# star 1
res = sum(v for k,v in contents.items() if v <= 100000)
print(res)

# star 2
outer = contents[()]
free = 70000000 - outer
remainder = 30000000 - free
best_key = min((k for k,v in contents.items() if v >= remainder), key=lambda k: contents[k])
print(contents[best_key])
