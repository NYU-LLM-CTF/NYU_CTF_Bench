
from fileparsing import *
from pwn import *


def get_binary(password, p, output_filename):
    p.recvuntil("continue:\n")
    p.send(password + b"\n")
    p.recvuntil("-------------------------------------------------------------------\n")
    file = p.recvuntil("-------------------------------------------------------------------\n")
    binary = parse_a_file(file)
    f = open(output_filename, "wb")
    f.write(binary)
    f.close()

def exploit_intermediate_binary(command, password, iteration, solver_function):
    p = process(command, shell=True)
    path_to_binary = b"./binary_" + str(iteration).encode()
    get_binary(password, p, path_to_binary)
    # This time I don't have to do anything with the binary to develop an exploit, but I will in the future.
    # I should pass in a function name and run it here.
    solver_function(p, path_to_binary)
    p.send("cat message.txt\n")
    message = p.recvuntil("box! ")
    new_command = p.recvuntil("and")[:-4]
    print("new command = " + str(new_command))
    p.recvuntil("password ")
    new_password = p.recvuntil("\n")[:-1]
    print("new password = " + str(new_password))
    p.close()
    return new_command, new_password

def exploit_final_binary(command, password, iteration, solver_function):
    p = process(command, shell=True)
    path_to_binary = b"./binary_" + str(iteration).encode()
    get_binary(password, p, path_to_binary)
    # This time I don't have to do anything with the binary to develop an exploit, but I will in the future.
    # I should pass in a function name and run it here.
    solver_function(p, path_to_binary)
    p.send("cat flag.txt\n")
    p.interactive()
