from Crypto.Cipher import AES
from Crypto.Hash import HMAC, SHA256
from Crypto import Random
#from Crypto.Random import random
import random
import base64
from functools import wraps
import json, sqlite3
from flask import session, redirect, url_for

def db_conn():
    dbh = sqlite3.connect('game.db', isolation_level=None)
    return dbh.cursor()

DLC = {
    1: 1,
    2: 2,
    3: 5,
    4: 0
}

DIRS = [
    [ 0, -1],
    [ 0,  1],
    [-1,  0],
    [ 1,  0],
]

NULL = 0
WALL = 1
HOLE = 2
LAVA = 3
MYSTERY = 4
SOIL  = 5
WATER = 6
STAIR = 7

enc_key = 'i#N@UXAD(V-2FGSbm)F#T9*VlVQglkLu'
hmac_key = 'gZ3np$hTE1jBTZoXS2uxF-ddNjDwj^FH'

def dist(x, y):
    return (x**2 + y**2)

def create_game():
    sz = 512
    st = {
        'world': [[0] * sz for i in range(sz)],
        'f': {
            'x': sz / 2,
            'y': sz / 2,
            'w': sz,
            'h': sz,
            'counter': 0,
            'food': 10,
            'level': 1,
            'max_hp': 10,
            'curr_hp': 10,
            'compass': False,
            'damaged': False,
            'sx': 0,
            'sy': 0,
        }
    }
    segs = f(st)
    d(st, segs)
    path = []
    user = get_user()
    db = db_conn()
    db.execute('UPDATE `users` SET `counter` = 0 WHERE `id` = ?', (user[0], ))
    return st

def register_user(usr, pwd):
    usr = usr.strip()
    db = db_conn()
    ret = db.execute('SELECT * FROM `users` WHERE `name` = ?', (usr, )).fetchone()
    if ret:
        return False
    db.execute('INSERT INTO `users` (`name`, `password`, `counter`) VALUES (?, ?, ?)', (usr, pwd, 0))
    session['id'] = db.lastrowid;
    if 'tokens' not in session:
        session['tokens'] = 0
    session['tokens'] += 3
    return True

def login_user(usr, pwd):
    usr = usr.strip()
    db = db_conn()
    ret = db.execute('SELECT * FROM `users` WHERE `name` = ? AND password = ?', (usr, pwd)).fetchone()
    if ret is None:
        return False
    session['id'] = ret[0]
    return True

def logout_user():
    del session['id']

def get_user():
    ret = None
    uid = session.get('id')
    if uid is not None:
        db = db_conn()
        ret = db.execute('SELECT * FROM `users` WHERE `id` = ?', (uid, )).fetchone()
    return ret

def compress_world(world, w, h):
    data = []
    cksm = 0
    i = 0x48
    for y in range(h):
        for x in range(w / 2):
            val = (
                (world[y][x * 2 + 0] << 4) |
                (world[y][x * 2 + 1] << 0)
            ) ^ i
            i = (i + 0xff) & 0xff
            cksm += val
            data.append(chr(val))

    data.append(chr(cksm & 0xff))
    return ''.join(data)

def decompress_world(data, w, h):
    sz = (w / 2) * h
    assert(len(data) == sz + 1)
    world = []
    cksm = 0
    i = 0x48
    for y in range(h):
        curr = []
        for x in range(w / 2):
            val = ord(data[(w / 2) * y + x])
            cksm += val
            val ^= i
            i = (i + 0xff) & 0xff
            hi = (val & 0xf0) >> 4
            lo = (val & 0x0f) >> 0
            curr.append(hi)
            curr.append(lo)
        world.append(curr)

    assert(ord(data[sz]) == (cksm & 0xff))
    return world

def decrypt_game(data):
    a, b = data.split(':', 1)
    a = base64.b64decode(a)
    b = base64.b64decode(b)
    h = HMAC.new(hmac_key, digestmod=SHA256)
    ctext = a[0:-SHA256.digest_size]
    hmac = a[-SHA256.digest_size:]
    h.update(ctext)
    assert(h.digest() == hmac)

    iv = ctext[0:AES.block_size]
    ctext_ = ctext[AES.block_size:]
    aes = AES.new(enc_key, AES.MODE_CBC, iv)
    f = json.loads(aes.decrypt(ctext_))
    world = decompress_world(b, f['w'], f['h'])
    st = {
        'f': f,
        'world': world
    }

    user = get_user()
    assert(user[3] == st['f']['counter'])

    return st

def encrypt_game(st):
    iv = Random.new().read(AES.block_size)
    aes = AES.new(enc_key, AES.MODE_CBC, iv)
    json_state = json.dumps(st['f'])
    ctext = iv + aes.encrypt(json_state + (' ' * (AES.block_size - len(json_state) % AES.block_size)))
    h = HMAC.new(hmac_key, digestmod=SHA256)
    h.update(ctext)
    a = ctext + h.digest()
    b = compress_world(st['world'], st['f']['w'], st['f']['h'])
    return ':'.join([base64.b64encode(a), base64.b64encode(b)])

def state_get(st, x, y):
    if x < 0: return NULL
    if x >= st['f']['w']: return NULL
    if y < 0: return NULL
    if y >= st['f']['h']: return NULL
    if st['world'][y][x] == NULL:
        st['world'][y][x] = random.randint(WALL, WATER)
    val = st['world'][y][x]
    return val if val <= STAIR else NULL

def state_data(st):
    x, y = st['f']['x'], st['f']['y']
    return [
        state_get(st, x - 1, y - 1),
        state_get(st, x + 0, y - 1),
        state_get(st, x + 1, y - 1),

        state_get(st, x - 1, y + 0),
        state_get(st, x + 0, y + 0),
        state_get(st, x + 1, y + 0),

        state_get(st, x - 1, y + 1),
        state_get(st, x + 0, y + 1),
        state_get(st, x + 1, y + 1),
    ]

def valid_action(st, mdir):
    if mdir < 0 or mdir >= len(DIRS):
        return False
    tile = state_get(st, st['f']['x'] + DIRS[mdir][0], st['f']['y'] + DIRS[mdir][1])
    return tile != NULL

def state_action(st, mdir):
    if st['f']['curr_hp'] <= 0:
        return 'You are dead.'

    user = get_user()
    db = db_conn()
    st['f']['counter'] += 1
    db.execute('UPDATE `users` SET `counter` = `counter` + 1 WHERE `id` = ?', (user[0], ))
    msg = 'You tried to do something weird. It fails and you lose 1 HP.'

    tile = NULL
    old_x = st['f']['x']
    old_y = st['f']['y']
    if valid_action(st, mdir):
        tile = state_get(st, st['f']['x'] + DIRS[mdir][0], st['f']['y'] + DIRS[mdir][1])
        if tile == WALL:
            st['f']['curr_hp'] -= 1
            st['f']['damaged'] = True
            msg = 'You walk into a wall and bump your nose. You lose 1 HP.'
            tile = state_get(st, st['f']['x'], st['f']['y'])
        else:
            st['f']['x'] += DIRS[mdir][0]
            st['f']['y'] += DIRS[mdir][1]

            if tile == HOLE:
                msg = 'You fall down a hole.'
                st['f']['damaged'] = True
                st['f']['curr_hp'] = 0
            elif tile == LAVA:
                msg = 'You walk into lava.'
            elif tile == MYSTERY:
                msg = 'You walk into something weird...'
            elif tile == SOIL:
                msg = 'You walk into some regular ground.'
            elif tile == WATER:
                msg = 'You wade into water. It takes extra energy.'
                if st['f']['food'] > 0:
                    st['f']['food'] -= 1
            elif tile == STAIR:
                msg = 'You found the exit... You win! ' + \
                      'You find the key on a piece of paper: KEY{H0000LY_ST41rRs_S0000_MUCH_SPACE}. ' + \
                      'Then a grue gets you.'
                if not st['f']['damaged']:
                    msg += ' Achievement Unlocked: KEY{W1NNER_W1NNER___NO_DAMAGE_DInneR1111}. '
                st['f']['curr_hp'] = 0
    else:
        st['f']['curr_hp'] -= 1
        st['f']['damaged'] = True

    if (old_x != st['f']['x'] or old_y != st['f']['y']) and st['f']['compass']:
        a = dist(old_x - st['f']['sx'], old_y - st['f']['sy'])
        b = dist(st['f']['x'] - st['f']['sx'], st['f']['y'] - st['f']['sy'])
        msg = "Your compass indicates " + ("you are going the wrong way" if a < b else "you are going the right way" if b < a else "you are getting nowhere") + '. ' + msg

    if st['f']['curr_hp'] > 0:
        if st['f']['food'] > 0:
            msg += ' You eat some food.'
            st['f']['food'] -= 1
            if st['f']['curr_hp'] < st['f']['max_hp']:
                msg += ' You regain 1 HP.'
                st['f']['curr_hp'] += 1
        else:
            msg += " You're hungry. You lose 1 HP."
            st['f']['damaged'] = True
            st['f']['curr_hp'] -= 1

        if tile == LAVA:
            msg += ' The lava cooks you. You lose 1 HP.'
            st['f']['damaged'] = True
            st['f']['curr_hp'] -= 1
        if tile == MYSTERY:
            if random.randint(0, 99) > 90:
                msg += 'Something flies at you.'
                st['f']['damaged'] = True
                st['f']['curr_hp'] = 0

    if st['f']['curr_hp'] <= 0:
        st['f']['damaged'] = True
        msg += ' You die.'
    return msg

def buy_item(st, bid):
    assert(bid >= 1 and bid <= 4)
    if DLC[bid] > session['tokens']:
        return 'Not enough tokens'
    session['tokens'] -= DLC[bid]

    if bid == 1:
        st['f']['food'] += 5
        return 'You got food!'

    if bid == 2:
        st['f']['curr_hp'] = 10
        return 'You were revived!'

    if bid == 3:
        st['f']['compass'] = True
        return 'You bought the compass!'

    if bid == 4:
        return 'nO-oP'

def debug_print(st):
    for row in st['world']:
        print ''.join(map(lambda x: '%s' % (x), row))

def clamp(val, lo, hi):
    return min(hi, max(lo, val))

def s(st, x, y):
    l = [
        [-1, -1], [0, -1], [1, -1],
        [-1,  0],          [1,  0],
        [-1,  1], [0,  1], [1,  1]
    ]
    for dx, dy in l:
        x_ = x + dx
        y_ = y + dy
        st['world'][y_][x_] = LAVA


def d(st, segs):
    x, y = st['f']['x'], st['f']['y']
    for i, sdata in enumerate(segs):
        sdir, slen = sdata
        typ = random.randint(LAVA, WATER)
        for _ in range(slen):
            x += sdir[0]
            y += sdir[1]
            st['world'][y][x] = typ
    st['world'][y][x] = STAIR
    st['f']['sx'] = x
    st['f']['sy'] = y

    s(st, x, y)

def mdist(x, y, st):
    return abs(st['f']['h'] / 2 - y) + abs(st['f']['w'] / 2 - x)

def f(st):
    cx, cy = st['f']['w'] / 2, st['f']['h'] / 2
    thres = int((cx + cy) / 1.7)
    nsegs = random.randint(thres / 2, thres)
    segs = []
    ldir = -1
    x, y = st['f']['x'], st['f']['y']
    i = 0

    while i < nsegs or mdist(x, y, st) < thres:
        dirs = [k for k, v in enumerate(DIRS) if k != ldir]
        idir = random.randint(0, len(dirs) - 1)
        ldir = dirs[idir]
        sdir = DIRS[ldir]
        slen = random.randint(1, 10)
        if mdist(x, y, st) > mdist(x + sdir[0], y + sdir[1], st) and random.randint(0, 10) > 7:
            slen /= 3

        ox = x
        oy = y
        nx = x + sdir[0] * slen
        ny = y + sdir[1] * slen
        x = clamp(nx, 0, st['f']['w'] - 1)
        y = clamp(ny, 0, st['f']['h'] - 1)
        slen -= abs(nx - x) + abs(ny - y)
        segs.append((sdir, slen))
        i += 1
    return segs
