from __future__ import print_function
from struct import unpack
from pwn import ELF, u64
from copy import copy


class RawNode(object):
    """
    A "raw" node. Basically a decoded node, but with child pointers unresolved
    """
    def __init__(self, is_terminal, lo, hi, inside_addr, outside_addr):
        self.is_terminal = is_terminal
        self.lo = lo
        self.hi = hi
        self.inside_addr = inside_addr
        self.outside_addr = outside_addr

    def __repr__(self):
        return 'RawNode({}, 0x{:x}, 0x{:x}, 0x{:x}, 0x{:x})'.format(
            self.is_terminal,
            self.lo,
            self.hi,
            self.inside_addr,
            self.outside_addr,
        )


class Node(object):
    """
    A full node, with child nodes being either None (if is_terminal), or other Nodes

    These nodes all have a name, from the symbol table (node_XXXXX)
    """
    def __init__(self, name, is_terminal, lo, hi, inside, outside):
        self.name = name
        self.is_terminal = is_terminal
        self.lo = lo
        self.hi = hi
        self.inside = inside
        self.outside = outside

    def __repr__(self):
        in_name = None
        if self.inside:
            in_name = self.inside.name
        out_name = None
        if self.outside:
            out_name = self.outside.name
        return 'Node({}, {}, 0x{:x}, 0x{:x}, {}, {})'.format(
            self.name,
            self.is_terminal,
            self.lo,
            self.hi,
            in_name,
            out_name,
        )


def decode_raw_node(binary, addr):
    data = binary.read(addr, 32)
    is_terminal, lo, hi, inside_addr, outside_addr = unpack('<?7xBB6xQQ', data)
    return RawNode(is_terminal, lo, hi, inside_addr, outside_addr)


def get_roots_addrs(binary):
    roots = []
    for start in range(
            binary.symbols['roots'], 
            binary.symbols['roots'] + 0x3b*8, 
            8):
        addr = binary.read(start, 8)
        roots.append(u64(addr))
    return roots


def get_root_node_names(root_addrs, node_addr_map):
    return [node_addr_map[addr] for addr in root_addrs]


def get_node_addr_map(binary):
    return {v:k for k,v in binary.symbols.items() if k.startswith('node_')}


def load_all_raw_nodes(binary, node_addr_map):
    all_nodes = {} # name -> raw node
    for addr, name in node_addr_map.items():
        all_nodes[name] = decode_raw_node(binary, addr)
    return all_nodes


def build_trees(raw_nodes, node_addr_map):
    built_nodes = {} # name -> Node
    analysis_remaining = copy(raw_nodes)
    # this is an iterative buildup -- we only build a node if both
    # of it's child nodes are built.
    while analysis_remaining:
        for name, raw_node in analysis_remaining.items():
            if raw_node.is_terminal: # terminals don't have children
                inside, outside = None, None
            else:
                inside = built_nodes.get(node_addr_map[raw_node.inside_addr], None)
                outside = built_nodes.get(node_addr_map[raw_node.outside_addr], None)
                if not (inside and outside):
                    continue # we don't have both yet
            node = Node(
                name,
                raw_node.is_terminal,
                raw_node.lo,
                raw_node.hi,
                inside,
                outside,
            )
            built_nodes[name] = node
            analysis_remaining.pop(name)
    return built_nodes


def solve_tree(root):
    frontier = [(list(range(256)), root)]
    while frontier:
        values, node = frontier.pop()
        if node.is_terminal:
            if node.lo: # node.lo == node.correct
                return chr(values[0])
            continue
        in_set = [x for x in values if node.lo <= x < node.hi]
        out_set = [x for x in values if not (node.lo <= x < node.hi)]
        frontier.append((in_set, node.inside))
        frontier.append((out_set, node.outside))
    raise ValueError('no node found D:')


if __name__ == '__main__':
    binary = ELF('rabbithole')
    print(binary)
    print('[+] FINDING ROOTS')
    root_addrs = get_roots_addrs(binary)
    print('[?] roots =', ', '.join(map(hex, root_addrs)))
    print('[+] FINDING NODES')
    node_addr_map = get_node_addr_map(binary)
    print('[?] {} nodes found'.format(len(node_addr_map)))
    print('[+] GETTING ROOT NODE NAMES')
    root_names = get_root_node_names(root_addrs, node_addr_map)
    print('[?] roots =', ', '.join(root_names))
    print('[+] DECODING RAW NODES')
    raw_nodes = load_all_raw_nodes(binary, node_addr_map)
    print('[?] {} raw nodes decoded'.format(len(raw_nodes)))
    print('[+] BUILDING NODE TREES')
    trees = build_trees(raw_nodes, node_addr_map)
    print('[?] {} nodes assembled'.format(len(trees)))
    roots = [trees[x] for x in root_names]
    print('[+] FINDING FLAG')
    flag = ''
    for root in roots:
        flag += solve_tree(root)
    print('[?] FLAG FOUND: {}'.format(flag))
