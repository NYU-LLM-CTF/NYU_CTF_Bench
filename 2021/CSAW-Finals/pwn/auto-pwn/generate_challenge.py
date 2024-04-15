
# 1. Create some test source code
# 2. Generate a test Makefile
# 3. Run the Makefile to generate a binary
# 4. Chmod +x the binary
# 5. Generate a flag file
# 6. Generate a DockerFile...



# 1. Create some test source code.
from generate_code import *
from utils import create_password
from gmpy2 import powmod, mpz
import os
flag=f"flag{{ROPcr4st1n4t10n_sh0uld_b3_4_b4nd_n4m3}}"
port_base = 11000
box = "auto-pwn.chal.csaw.io"#"localhost" #"auto-pwn.chal.csaw.io" #"3.15.225.220" 

from random import *
seed = 22340897

N =  40#10
level_one_threshold = 20#5
level_two_threshold = 20#5
# challenges_per_level = 20 # Not used, just a note to myself here
os.system("mkdir binaries")
os.chdir("./binaries")
next_password = None # The password for the (n+1)th binary in the chain. Starts as none because we construct the chain backwards, starting at N.
for round_number in range(N, 0, -1):
    #print("round_number = " + str(round_number))
    os.system("mkdir round_{}".format(round_number))
    os.chdir("./round_{}".format(round_number))
    password = create_password(seed)
    seed = int(powmod(mpz(seed),234234,120987234))
    if round_number > level_one_threshold: #level two
        generate_level_two_source_code(filename_stem="binary_{}".format(round_number), password=password, random_seed=seed)
        seed = int(powmod(mpz(seed),234234,120987234))
        os.system("gcc -no-pie -fno-pie binary_{0}.c -o binary_{0}".format(round_number))
        os.system("xxd binary_{0} > binary_{0}.txt".format(round_number))
        # Generate Dockerfile
        if round_number == N:
            os.system("echo {0} > flag.txt".format(flag))
            generate_final_Dockerfile(level='2', filename="Dockerfile", round_number=round_number, port_base=port_base)
        else:
            os.system("echo \"Sorry, but your flag is in another box! nc {0} {1} and use password {2}\" > message.txt".format(box, (port_base+round_number+1), next_password))
            os.system("cp ../round_{0}/binary_{0} ./binary_{0}".format((round_number+1)))
            generate_intermediate_Dockerfile(level='2', filename="Dockerfile", round_number=round_number, port_base=port_base)
    else: #level one
        generate_level_one_source_code(filename_stem="binary_{}".format(round_number), password=password, random_seed=seed)
        seed = int(powmod(mpz(seed),234234,120987234))
        os.system("gcc -pie -fno-stack-protector binary_{0}.c -o binary_{0}".format(round_number))
        os.system("xxd binary_{0} > binary_{0}.txt".format(round_number))
        # Generate Dockerfile
        if round_number == N:
            os.system("echo {0} > flag.txt".format(flag))
            generate_final_Dockerfile(level='1', filename="Dockerfile", round_number=round_number, port_base=port_base)
        else:
            os.system("echo \"Sorry, but your flag is in another box! nc {0} {1} and use password {2}\" > message.txt".format(box, (port_base+round_number+1), next_password))
            os.system("cp ../round_{0}/binary_{0} ./binary_{0}".format((round_number+1)))
            generate_intermediate_Dockerfile(level='1', filename="Dockerfile", round_number=round_number, port_base=port_base)
    os.system("docker build --tag=binary_{0} .".format(round_number))
    os.system("docker run -dit --restart=always -p {0}:5000 binary_{1}".format(port_base+round_number, round_number))
    os.chdir("..")
    next_password = password
os.chdir("..")
# Print the password for the first binary
os.system("echo {0} > first_password.txt".format(next_password))
