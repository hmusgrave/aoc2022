with open('data/day_4.txt') as f:
    data = f.read()

def foo(rev):
    tab, moves = data.split('\n\n')
    tab = [[c for c in L if c != ' '] for L in zip(*(line[1::4] for line in tab.split('\n')[::-1][1:]))]
    moves = [list(map(int, line.split(' ')[1::2])) for line in moves.split('\n') if line.strip()]

    def apply(move):
        n, src, dst = move
        src, dst = tab[src-1], tab[dst-1]
        if rev:
            dst.extend(src[-n:][::-1])
        else:
            dst.extend(src[-n:])
        src[-n:] = []

    for move in moves:
        apply(move)

    return ''.join(t[-1] for t in tab)

print(foo(True))
print(foo(False))
