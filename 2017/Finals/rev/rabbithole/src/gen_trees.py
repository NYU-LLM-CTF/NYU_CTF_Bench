import random


_max_node_id = 0
def next_node_id():
    global _max_node_id
    i = _max_node_id
    _max_node_id += 1
    return i


class Node:
    def __init__(self, valid_set):
        self.id = next_node_id()
        self.valid_set = valid_set
        self.lo = None
        self.hi = None
        self.t_side = None
        self.f_side = None
    
    def __repr__(self):
        return 'Node({}, {}, {})'.format(self.id, self.lo, self.hi)

    def c_struct(self):
        return f"""
struct node node_{self.id} = {{
    .is_terminal = false,
    .lo = {self.lo},
    .hi = {self.hi},
    .t_side = &node_{self.t_side.id},
    .f_side = &node_{self.f_side.id},
}};"""


    def split(self, correct_value):
        """
        Split this node into true and false sides, generate children
        """
        a, b = random.choice(self.valid_set), random.choice(self.valid_set)
        self.lo, self.hi = min(a, b), max(a, b)

        in_set = [x for x in self.valid_set if self.lo <= x < self.hi]
        out_set = [x for x in self.valid_set if not (self.lo <= x < self.hi)]

        if not in_set:
            self.t_side = TerminalNode(False)
        elif len(in_set) == 1:
            self.t_side = TerminalNode(in_set[0] == correct_value)
        else:
            self.t_side = Node(in_set)

        if not out_set:
            self.f_side = TerminalNode(False)
        elif len(out_set) == 1:
            self.f_side = TerminalNode(out_set[0] == correct_value)
        else:
            self.f_side = Node(out_set)


class TerminalNode:
    def __init__(self, correct):
        self.id = next_node_id()
        self.correct = correct

    def c_struct(self):
        return f"""
struct node node_{self.id} = {{
    .is_terminal = true,
    .correct = {str(self.correct).lower() },
}};"""


    def __repr__(self):
        return 'TerminalNode({}, {})'.format(self.id, self.correct)


def generate_tree(correct_value, value_set):
    root = Node(value_set)
    all_nodes = [root]
    frontier = [root]
    while frontier:
        node = frontier.pop()
        node.split(correct_value)

        for s in node.t_side, node.f_side:
            if not isinstance(s, TerminalNode):
                frontier.append(s)
            all_nodes.append(s)

    return root, all_nodes


def print_tree(node, indent_level=0):
    indent = '\t' * indent_level
    print(indent, node)
    if not isinstance(node, TerminalNode):
        print_tree(node.t_side, indent_level+1)
        print_tree(node.f_side, indent_level+1)


if __name__ == '__main__':
    flag = 'flag{b3g1n_47_7h3_b3g1nn1ng_4nd_g0_0n_t1ll_y0u_h1t_th3_3nd}'

    roots = []
    generated_chars = {}
    for c in flag:
        # just point characters we've already generated at the same place
        if c in generated_chars:
            roots.append(generated_chars[c])
            continue

        root, all_nodes = generate_tree(ord(c), list(range(256)))
        generated_chars[c] = root
        roots.append(root)
        #print_tree(root)

        # Generate forward declarations
        for node in all_nodes:
            print('struct node node_{id};'.format(id=node.id))
        # Generate nodes
        for node in all_nodes:
            print(node.c_struct())

    print('struct node *roots[] = {{ {} }};'.format(
        ', '.join('&node_{}'.format(n.id) for n in roots)
    ))
