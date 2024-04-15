
# The flaw lies in using AES with CTR mode, reusing key and iv
# This solver works on a Windows VM used to create the challenge
#      (and which participants would use to reverse the binary). 
#      To test it and get the flag outside a VM or in Linux, just change the 
#      file paths at the bottom.

bs = 1024

def xor_two_byte_strings(bs1, bs2):
    out = b''
    l = min(len(bs1), len(bs2))
    for i in range(l):
        out += bytes([(bs1[i]^bs2[i])])
    return out

def decrypt(file1_pt, file1_ct, file2_ct, out_file):
    done = False
    while not done:
        file1_pt_chunk = file1_pt.read(1024*bs)
        file1_ct_chunk = file1_ct.read(1024*bs)
        file2_ct_chunk = file2_ct.read(1024*bs)
        if len(file1_pt_chunk) != 0 and len(file1_ct_chunk) != 0 and len(file2_ct_chunk) != 0:
            tmp = xor_two_byte_strings(xor_two_byte_strings(file1_ct_chunk, file2_ct_chunk),file1_pt_chunk)
            out_file.write(tmp)
        else:
            done=True

def decrypt_wrapper(file1_pt_filename, file1_ct_filename, file2_ct_filename, out_filename):
    with open(file1_pt_filename, 'rb') as file1_pt, \
         open(file1_ct_filename, 'rb') as file1_ct, \
         open(file2_ct_filename, 'rb') as file2_ct, \
         open(out_filename, 'wb') as out_file:
        decrypt(file1_pt, file1_ct, file2_ct, out_file)

decrypt_wrapper(file1_pt_filename="C:\\Users\\IEUser\\SecretCSAWDocuments\\Copies\\2020_IC3Report.pdf", \
                file1_ct_filename="C:\\Users\\IEUser\\SecretCSAWDocuments\\cad0b75505847a4792a67bb33ece21ec9c7bd21395ca6b158095d92772e01637.pdf.cryptastic", \
                file2_ct_filename="C:\\Users\\IEUser\\SecretCSAWDocuments\\ea6b505ffded681a256232ed214d4c3b410c8b4f052775eb7e67dcbd5af64e63.pdf.cryptastic",\
                out_filename="C:\\Users\\IEUser\\SecretCSAWDocuments\\flag_solved.pdf")


