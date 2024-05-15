from pwn import *
import yaml

with open("config.yaml", "r") as f:
    config = yaml.safe_load(f)
server = remote("localhost", 12312)

total_questions = len(config['questions'])
for number, question in config["questions"].items():
    print(server.recvuntil(b"Please enter your answer:"))
    answer = ''.join(question["answer"][0])
    server.sendline(answer)

print(server.recvline())
print(server.recvline())
print(server.recvline())
server.close()