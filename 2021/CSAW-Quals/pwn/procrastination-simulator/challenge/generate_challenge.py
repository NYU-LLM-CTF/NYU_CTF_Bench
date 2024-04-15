
# 1. Create some test source code
# 2. Generate a test Makefile
# 3. Run the Makefile to generate a binary
# 4. Chmod +x the binary
# 5. Generate a flag file
# 6. Generate a DockerFile...



# 1. Create some test source code.


from generate_code import generate_example_challenge_source_code
from generate_code import generate_final_Dockerfile
from generate_code import generate_intermediate_Dockerfile
from generate_code import generate_final_level_four_Dockerfile
from generate_code import generate_intermediate_level_four_Dockerfile
from generate_code import generate_level_one_source_code
from generate_code import generate_level_two_source_code
from generate_code import generate_level_three_source_code
from generate_code import generate_level_four_source_code
from utils import create_password
from gmpy2 import powmod, mpz
import os
flag=f"flag{{c0ngr4tul4t10ns,4ut0-pwn3r!5h0ut0ut5_t0_UTCTF_f0r_th31r_3xc3ll3nt_AEG_ch4ll3ng3_1n_M4y}}"
port_base = 11000
box = "localhost" #"auto-pwn.chal.csaw.io"

from random import seed
challenge_seed = 22340897
#seed(seed)

N = 50 # 11 # 50
level_one_threshold = 15 # 2 # 15
level_two_threshold = 30 # 4 # 30
level_three_threshold = 45 # 6 # 45
#level_two_threshold = 4
# challenges_per_level = 20 # Not used, just a note to myself here
os.system("mkdir binaries")
os.chdir("./binaries")
next_password = None # The password for the (n+1)th binary in the chain. Starts as none because we construct the chain backwards, starting at N.
for round_number in range(N, 0, -1):
    #print("round_number = " + str(round_number))
    os.system("mkdir round_{}".format(round_number))
    os.chdir("./round_{}".format(round_number))
    challenge_seed = int(powmod(mpz(challenge_seed),234234,120987234))
    password = create_password(challenge_seed)
    if round_number > level_three_threshold: # level 4
        generate_level_four_source_code(filename_stem="binary_{}".format(round_number), password=password, random_seed=challenge_seed)
        seed = int(powmod(mpz(challenge_seed),234234,120987234))
        os.system("gcc binary_{0}.c -fPIE -pie -Wl,-z,norelro -o binary_{0}".format(round_number))
        os.system("strip binary_{0}".format(round_number))
        os.system("xxd binary_{0} > binary_{0}.txt".format(round_number))
        # Generate Dockerfile
        if round_number == N:
            os.system("echo {0} > flag.txt".format(flag))
            generate_final_level_four_Dockerfile(filename="Dockerfile", round_number=round_number, port_base=port_base)
        else:
            os.system("echo \"Sorry, but your flag is in another box! nc {0} {1} and use password {2}\" > message.txt".format(box, (port_base+round_number+1), next_password))
            os.system("cp ../round_{0}/binary_{0} ./binary_{0}".format((round_number+1)))
            generate_intermediate_level_four_Dockerfile(filename="Dockerfile", round_number=round_number, port_base=port_base) # It's fine for all Docker containers to have i386 support
    elif round_number > level_two_threshold: # level 3
        generate_level_three_source_code(filename_stem="binary_{}".format(round_number), password=password, random_seed=challenge_seed) # Source code is the same
        challenge_seed = int(powmod(mpz(challenge_seed),234234,120987234))
        os.system("gcc -fpie -no-pie binary_{0}.c -o binary_{0}".format(round_number))
        os.system("strip binary_{0}".format(round_number))
        os.system("xxd binary_{0} > binary_{0}.txt".format(round_number))
        # Generate Dockerfile
        if round_number == N:
            os.system("echo {0} > flag.txt".format(flag))
            generate_final_Dockerfile(filename="Dockerfile", round_number=round_number, port_base=port_base)
        else:
            os.system("echo \"Sorry, but your flag is in another box! nc {0} {1} and use password {2}\" > message.txt".format(box, (port_base+round_number+1), next_password))
            os.system("cp ../round_{0}/binary_{0} ./binary_{0}".format((round_number+1)))
            generate_intermediate_Dockerfile(filename="Dockerfile", round_number=round_number, port_base=port_base) # It's fine for all Docker containers to have i386 support
    elif round_number > level_one_threshold: # level 2
        generate_level_two_source_code(filename_stem="binary_{}".format(round_number), password=password, random_seed=challenge_seed)
        challenge_seed = int(powmod(mpz(challenge_seed),234234,120987234))
        os.system("gcc -fpie -no-pie binary_{0}.c -o binary_{0}".format(round_number))
        os.system("xxd binary_{0} > binary_{0}.txt".format(round_number))
        # Generate Dockerfile
        if round_number == N:
            os.system("echo {0} > flag.txt".format(flag))
            generate_final_Dockerfile(filename="Dockerfile", round_number=round_number, port_base=port_base)
        else:
            os.system("echo \"Sorry, but your flag is in another box! nc {0} {1} and use password {2}\" > message.txt".format(box, (port_base+round_number+1), next_password))
            os.system("cp ../round_{0}/binary_{0} ./binary_{0}".format((round_number+1)))
            generate_intermediate_Dockerfile(filename="Dockerfile", round_number=round_number, port_base=port_base) # It's fine for all Docker containers to have i386 support
    else:
        generate_level_one_source_code(filename_stem="binary_{}".format(round_number), password=password, random_seed=challenge_seed)
        challenge_seed = int(powmod(mpz(challenge_seed),234234,120987234))
        os.system("gcc -m32 -fpie -no-pie binary_{0}.c -o binary_{0}".format(round_number))
        os.system("xxd binary_{0} > binary_{0}.txt".format(round_number))
        # Generate Dockerfile
        if round_number == N:
            os.system("echo {0} > flag.txt".format(flag))
            generate_final_Dockerfile(filename="Dockerfile", round_number=round_number, port_base=port_base)
        else:
            os.system("echo \"Sorry, but your flag is in another box! nc {0} {1} and use password {2}\" > message.txt".format(box, (port_base+round_number+1), next_password))
            os.system("cp ../round_{0}/binary_{0} ./binary_{0}".format((round_number+1)))
            generate_intermediate_Dockerfile(filename="Dockerfile", round_number=round_number, port_base=port_base)
    os.system("docker build --tag=binary_{0} .".format(round_number))
    os.system("docker run -dit --restart=always -p {0}:5000 binary_{1}".format(port_base+round_number, round_number))
    os.chdir("..")
    next_password = password
os.chdir("..")
# Print the password for the first binary
os.system("echo {0} > first_password.txt".format(next_password))
