def parse_a_line(line):
    #print("in parse_a_line: line = " + str(line))
    cursor = line.find(b":")+1
    these_bytes = b''
    #print("Received from recv_a_line: " + str(p.recvuntil(":")))
    for i in range(8):
        cursor += 1
        these_bytes_string = line[cursor:cursor+4]
        #print("these_bytes_string = " + str(these_bytes_string))
        these_bytes += binascii.unhexlify(these_bytes_string)
        cursor += 4
        #print("these_bytes_string = " + str(these_bytes_string))
        #print("these_bytes_string class = " + str(these_bytes_string.__class__))
        #print("these_bytes = " + str(these_bytes))
    #p.recvuntil("\n")
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
        print("next_line = " + str(next_line))
        if"-------------------------------------------------------------------" in next_line:
            print("Got the ending text. Finished parsing the file.")
            done = True
            break
        file = file[file.find(b"\n")+1:]
        print("new file length = " + str(len(file)))
        line_bytes = parse_a_line(next_line)
        #print("finished parse_a_line")
        if line_bytes == "-1":
            print("Got -1 back from parse_a_line. Remainder of the file is: " + str(file))
            done = True
            break
        file_bytes += line_bytes
    print("length of file_bytes: " + str(len(file_bytes)))
    return(file_bytes)