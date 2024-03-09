import pefile


def encrypt1(var, key):
    return bytes(a ^ key for a in var)


if __name__ == "__main__":
    fp = "..\\build\\main_out.exe"
    pe = pefile.PE(fp)
    for section in pe.sections:
        if section.Name.startswith(b'.text'):
            print("Found the .text header")
            data = section.get_data()
            print('Writing data to ..\\..\\sc.dat')
            with open('../sc.dat', 'wb') as f:
                cipher = encrypt1(data, 0x25)
                f.write(cipher)
            print('done')
