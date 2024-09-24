"""
blacklist.py

    Module that is seperated and kept secret, as it contains all the banned keywords
    that cannot be executed in the sandbox.
"""

# an incredibly restrictive blacklist. Player should craft a numpy escape.
BLACKLIST = [
    "__builtins__",
    "__import__",
    "eval",
    "exec",
    "import",
    "from",
    "os",
    "sys",
    "system",
    "timeit",
    "base64"
    "commands",
    "subprocess",
    "pty",
    "platform",
    "open",
    "read",
    "write",
    "dir",
    "type",
]

# a less restrictive blacklist for the 2nd sandbox. Player can use any other payload to read the flag.txt on server.
BLACKLIST2 = [
    "eval",
    "exec",
    "import",
    "from",
    "timeit",
    "base64"
    "commands",
    "subprocess",
    "pty",
    "platform",
    "write",
    "dir",
    "type",
]
