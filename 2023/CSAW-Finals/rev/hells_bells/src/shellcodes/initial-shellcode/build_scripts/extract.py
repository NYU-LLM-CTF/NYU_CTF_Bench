import pefile
from arc4 import ARC4

if __name__ == "__main__":
    fp = "..\\build\\main_out.exe"
    pe = pefile.PE(fp)
    for section in pe.sections:
        if section.Name.startswith(b'.text'):
            print("Found the .text header")
            data = section.get_data()
            print('Writing data to ..\\..\\sc.dat')
            with open('../sc.dat', 'wb') as f:
                arc4 = ARC4(b'Y0u_Got_m3_r1ng1ng_H3lls_beLl5')
                cipher = arc4.encrypt(data)
                f.write(cipher)
            print('done')
