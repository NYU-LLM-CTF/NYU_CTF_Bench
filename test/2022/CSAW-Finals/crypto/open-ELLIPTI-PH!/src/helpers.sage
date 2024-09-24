import binascii

# DON'T EXPOSE THIS FILE!!

def help_gen_kpri(flag):
    return int(binascii.hexlify(flag.encode()),16) % 100000