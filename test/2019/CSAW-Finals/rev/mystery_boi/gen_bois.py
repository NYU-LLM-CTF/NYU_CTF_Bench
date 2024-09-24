#!/usr/bin/python
import random
import math
from jinja2 import Environment, FileSystemLoader

flag = "flag{jk_there_was_no_mystery}"

keymap = {}


class Node(object):
    def __init__(self, value):
        self.children = set()
        self.value = value
        self.key = 0
        keymap[value] = self

    def __repr__(self):
        return "%s -> %s" % (self.value, self.children)


def break_group(group):
    if len(group) <= 2:
        return group
    groups = []
    while group:
        subset_size = random.randint(1, round(len(group)))
        subset = [group.pop() for i in range(subset_size)]
        groups.append(subset)
        if subset_size > 8:
            fragments = break_group(subset)
            for fragment in fragments:
                groups.append(fragment)
    return groups


def groupify(group):
    cur = group[0]

    for i in range(1, len(group) - 1):
        cur.children.add(group[i])
        cur = group[i]

    cur.children.add(group[-1])
    group[-1].children.add(group[0])


charset = list(range(97, 123)) + list(range(48, 48 + 10))
charset = list(map(chr, charset))
charset += ["{", "}", "_"]
charset = list(map(Node, charset))
list_of_chars = list(charset)

random.Random(4).shuffle(charset)

for c in range(len(charset)):
    charset[c].key = c


MAX_GROUP_SIZE = 2

groups = [i for i in break_group(charset) if i]


for i in range(len(groups)):
    groupify(groups[i])

file_loader = FileSystemLoader("templates")
env = Environment(loader=file_loader)


uniq_count = 10


def gen_name(w):
    n = 0
    for i in range(len(w)):
        n |= ord(w[i]) << i * 8

    return hex(n)


def gen_file(group):
    """
    """
    global uniq_count
    t = env.get_template("group_checker.jinja")
    uniq_name = "boi%d" % (uniq_count)
    uniq_count += 1
    output = t.render(group=group, file_name=gen_name(uniq_name))
    with open("mystery_bois/%s.c" % (uniq_name), "w") as FILE:
        f = FILE.write(output)
    return uniq_name


def gen_boi8(uniqs):
    uniq_names = [[i, gen_name(i)] for i in uniqs]

    t = env.get_template("boi8.jinja")
    output = t.render(uniq_names=uniq_names)

    with open("mystery_bois/boi8.c", "w") as FILE:
        f = FILE.write(output)


def gen_boi9(components):
    t = env.get_template("boi9.jinja")
    output = t.render(testcases=components)

    with open("mystery_bois/boi9.c", "w") as FILE:
        f = FILE.write(output)


uniq_names = [gen_file(i) for i in groups]
print(uniq_names)
gen_boi8(uniq_names)
boi9_checker = [[c, keymap[c].key] for c in flag]
gen_boi9(boi9_checker)
