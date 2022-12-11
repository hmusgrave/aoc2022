with open('data/day_10.txt') as f:
    data = f.read()

import io
from collections import defaultdict

def parse_monkey(m):
    m = list(io.StringIO(m))
    m = [s.strip() for s in m if s.strip()]
    m = m[1:]
    start = m[0].split('Starting items: ')[-1]
    start = list(map(int, start.split(',')))
    op = m[1].split('Operation: new = ')[-1]
    test = m[2].split('Test: ')[-1].replace('divisible by ', 'new % ')
    monk_true = int(m[3].split('monkey ')[-1])
    monk_false = int(m[4].split('monkey ')[-1])
    return [start, op, test, monk_true, monk_false]

def parse():
    return list(map(parse_monkey, data.split('\n\n')))

def run(monkeys, k=None):
    t = defaultdict(int)
    for i,m in enumerate(monkeys):
        for old in m[0]:
            new = eval(m[1])  # I read the input, it's fine
            if k is None:
                new //= 3
            else:
                new %= 11 * 17 * 13 * 19 * 2 * 3 * 7 * 5
            if 0 == eval(m[2]):
                monkeys[m[3]][0].append(new)
            else:
                monkeys[m[4]][0].append(new)
        t[i] += len(m[0])
        m[0].clear()
    return t

def merge(a, *args):
    for b in args:
        for k,v in b.items():
            a[k] += v
    return a

def runn(monkeys, n, k):
    return merge(*(run(monkeys, k) for _ in range(n)))

def star1():
    v = sorted(runn(parse(), 20, None).values())[-2:]
    return v[0] * v[1]

def star2():
    v = sorted(runn(parse(), 10000, 1).values())[-2:]
    return v[0] * v[1]

print(star1())
print(star2())

