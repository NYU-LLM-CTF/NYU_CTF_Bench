from io import BytesIO
import pyzipper
import png
import deflate
import zlib
import sys
if len(sys.argv) == 1:
    print(f'\x1b[91m[!] Usage: python exp.py file_path\ne.g. python exp.py ../attachment/attachment.zip\x1b[0m')
    exit(0)
zipname = sys.argv[1]
print(zipname)
pwd = zlib.decompress(open(zipname, 'rb').read().split(b'password.txt\xCB\xCB\x2F\xC9\xC8\xCC\x4B\x57\xC8'
                                                                b'\x48\x2D\x4A\x55\x04\x00')[1].split(
                                                                b'\x50\x4B\x01\x02\x14\x00')[0], -15)
print(f'\x1b[92m[*] The password is:{pwd.decode()}\x1b[0m')
zf = pyzipper.ZipFile(zipname)
flag_file = zf.read('flag.zip')
zf = pyzipper.AESZipFile(BytesIO(flag_file))
pngfile = zf.read('flag.png', pwd)
r = png.Reader(bytes=pngfile)
zlib_data, filter_li, out = b'', [], BytesIO()
for chunk_type, chunk_data in r.chunks():
    if chunk_type == b'IDAT':
        zlib_data += chunk_data
raw_data = zlib.decompress(zlib_data)
for i in range(0, len(raw_data), 2401):
    filter_li.append(raw_data[i])
print(f'\x1b[92m[*] filter type:{filter_li}\x1b[0m')
decom = deflate.Decompressor(deflate.BitInputStream(BytesIO(zlib_data[2:-4])),
                             out)  # 这里的data是png的idat块去掉zlib头以及adler32校验后的数据
print(f'\x1b[92m[*] deflate type:{decom.typeli}\x1b[0m')
flag_filter, flag_deflate = '', ''
for i in range(0, len(filter_li), 8):
    try:
        flag_filter += chr(int(''.join([str(c) for c in filter_li[i:i + 8]]), 2))
    except:
        pass
print(f'\x1b[92m[*] filter part:{flag_filter}\x1b[0m')
deflate_type = ''.join([str(c) for c in decom.typeli]).replace('0', '').replace('1', '0').replace('2', '1')
for i in range(0, len(deflate_type), 8):
    try:
        flag_deflate += chr(int(''.join([str(c) for c in deflate_type[i:i + 8]]), 2))
    except:
        pass
print(f'\x1b[92m[*] deflate part:{flag_deflate}\x1b[0m')
print(f'\x1b[92m[*] flag:{flag_filter + flag_deflate}\x1b[0m')