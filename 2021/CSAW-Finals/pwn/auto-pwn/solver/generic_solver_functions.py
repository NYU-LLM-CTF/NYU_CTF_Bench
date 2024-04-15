from fileparsing import *
from pwn import *
import os

def get_binary(password, p, output_filename):
    p.recvuntil("continue:\n")
    p.send(password + b"\n")
    p.recvuntil("-------------------------------------------------------------------\n")
    file = p.recvuntil("-------------------------------------------------------------------\n")
    binary = parse_a_file(file)
    print("got binary "+output_filename)
    f = open(output_filename, "wb")
    f.write(binary)
    f.close()

def exploit_intermediate_binary(command, password, iteration, solver_function):
    p = process(command, shell=True)
    #path_to_binary = b"binary_" + str(iteration).encode()
    path_to_binary = os.path.dirname(os.path.abspath(__file__)) + "/" + "binary_" + str(iteration)
    print("getting binary "+path_to_binary)
    get_binary(password, p, path_to_binary)
    # This time I don't have to do anything with the binary to develop an exploit, but I will in the future.
    # I should pass in a function name and run it here.
    solver_function(p, path_to_binary)
    # without sleeping the cat message gets dropped often
    time.sleep(0.5)
    p.send("cat message.txt\n")
    message = p.recvuntil("box! ")
    new_command = p.recvuntil("and")[:-4]
    print("new command = " + str(new_command))
    p.recvuntil("password ")
    new_password = p.recvuntil("\n")[:-1]
    print("new password = " + str(new_password))
    p.close()
    if (not new_command) or (not new_password):
        raise Exception
    return new_command, new_password

def exploit_final_binary(command, password, iteration, solver_function):
    p = process(command, shell=True)
    #gdb.attach(proc.pidof(p)[0], "b writeShirt")
    path_to_binary = os.path.dirname(os.path.abspath(__file__)) + "/" + "binary_" + str(iteration)
    get_binary(password, p, path_to_binary)
    # This time I don't have to do anything with the binary to develop an exploit, but I will in the future.
    # I should pass in a function name and run it here.
    solver_function(p, path_to_binary)
    p.send("cat flag.txt\n")
    p.interactive()
