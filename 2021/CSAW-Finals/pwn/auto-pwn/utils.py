
import random

def create_password(seed):
    password = hex(random.getrandbits(128))[2:]
    password = "0"*(32-len(password))+password
    return password

def write_file(filename):
    f = open(filename, "w")
    f.write(file_content)
    f.close()