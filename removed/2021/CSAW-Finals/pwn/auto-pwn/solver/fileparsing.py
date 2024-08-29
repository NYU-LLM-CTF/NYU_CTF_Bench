
import binascii

# Need to check that bytes are correct. The last line doesn't necessarily contain 16 bytes.
def is_valid_hex_byte(b):
    if ((b >= 0x30 and b <= 0x39)):
        return True
    elif (b >= ord('a') and b <= ord('f')):
        return True
    return False
    #return ((ord(c) >= 0x30 && ord(c) <= 0x39) || (ord(c) >= ord('a') && ord(c) <= ord('f')))

def are_valid_hex_bytes(bs):
    result = True
    if len(bs)%2 != 0:
        return False
    for i in range(len(bs)):
        if not(is_valid_hex_byte(bs[i])):
            result = False
    return result

def parse_a_line(line):
    #print("in parse_a_line: line = " + str(line))
    cursor = line.find(b":")+1
    these_bytes = b''
    #print("Received from recv_a_line: " + str(p.recvuntil(":")))
    for i in range(8):
        cursor += 1
        these_bytes_string = line[cursor:cursor+4]
        if not(are_valid_hex_bytes(these_bytes_string)): # We're probably on the last line
            print(b"Encountered invalid hex bytes: " + these_bytes_string)
            break
        #print("these_bytes_string = " + str(these_bytes_string))
        these_bytes += binascii.unhexlify(these_bytes_string)
        cursor += 4
    if (these_bytes == b''):
        print("Error in recv_a_line: didn't get anything.")
        return("-1")
    #print("returning from parse_a_line: " + str(these_bytes))
    return(these_bytes)
    

def parse_a_file(file):
    done = False
    file_bytes = b''
    while not done:
        next_line = file[:file.find(b"\n")+1]
        #print("next_line = " + str(next_line))
        if b"-------------------------------------------------------------------" in next_line:
            print("Got the ending text. Finished parsing the file.")
            done = True
            break
        file = file[file.find(b"\n")+1:]
        #print("new file length = " + str(len(file)))
        #print(b"Parsing line: " + next_line)
        line_bytes = parse_a_line(next_line)
        #print("finished parse_a_line")
        if line_bytes == "-1":
            print("Got -1 back from parse_a_line. Remainder of the file is: " + str(file))
            done = True
            break
        file_bytes += line_bytes
    print("length of file_bytes: " + str(len(file_bytes)))
    return(file_bytes)
