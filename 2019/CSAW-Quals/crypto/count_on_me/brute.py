import random


def random_bytes():
    return random.getrandbits(32).to_bytes(16, 'little')


def brute(n):
    x = 0
    while True:
        random.seed(x)
        collisions = {}
        for i in range(100):
            curr = random_bytes()
            if curr not in collisions:
                collisions[curr] = i
            for j in range(2):
                test = random_bytes()
                if test in collisions and j == n:
                    return x, i, j, collisions[test]
        x += 1


if __name__ == '__main__':
    print(brute(0))
    print(brute(1))
