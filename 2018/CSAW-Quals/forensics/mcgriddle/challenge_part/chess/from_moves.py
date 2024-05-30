from pwn import *

p = remote('ctf-tools.osiris.cyber.nyu.edu', 9998)

moves = []
with open('final', 'r') as movelist:
    moves = movelist.read().split('\n')

content = p.recvuntil(') :')
boards = []
for move in moves:
    p.sendline(move)
    content = p.recvuntil(') :')
    l = content.split('\n')
    boards.append(l[5:13])
i = 0
content_count = 0
for board in boards:
    print "\n\n======================================\n\n"
    print i
    for b in board:
        content_count += b.count('.')
    print content_count
    print "\n"
    print "\n".join(board)
    i+=1

print len(boards)
