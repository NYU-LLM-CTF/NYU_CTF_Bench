from pwn import *
import yaml

with open("config.yaml", "r") as f:
    config = yaml.safe_load(f)
server = remote("localhost", 5000)

total_questions = len(config['questions'])
for number, question in config["questions"].items():
    print(server.recvuntil(b"Please enter your answer:"))
    server.sendline((','.join(question["answer"])).encode())

print(server.recvline())
print(server.recvline())
print(server.recvline())
server.close()