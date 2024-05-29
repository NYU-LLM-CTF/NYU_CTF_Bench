import requests
import random
import string
import base64

def fill_in_blanks(blanks_arr, payload, start_index = 0):
    #payload is a list of chars
    char_count = start_index 
    x_count = 0
    for row in range(len(blanks_arr)):
        blanks_arr[row] = list(blanks_arr[row])
        for col in range(len(blanks_arr[row])):
            cell = blanks_arr[row][col]
            if cell == '.':
                try:
                    blanks_arr[row][col] = payload[char_count]
                    char_count += 1
                except:
                    blanks_arr[row][col] = "!"
                    char_count = 0
                    x_count += 1
            elif cell != " ":
                blanks_arr[row][col] = "!"
                x_count += 1
    return char_count, x_count


def gen_random_b64(count):
    b64_acceptable = string.ascii_letters + string.digits + "/+"
    acceptable = list(b64_acceptable)
    return random.choices(acceptable, k=count)
    

def fill_in_blocked(start_arr, payload):
    #payload is a list of chars
    x_count = 0
    for row in range(len(start_arr)):
        start_arr[row] = list(start_arr[row])
        for col in range(len(start_arr[row])):
            cell = start_arr[row][col]
            if cell == '!':
                start_arr[row][col] = payload[x_count]
                x_count += 1

def full_payload(array, contents, start_index):
   end_index, blocked_count = fill_in_blanks(array, contents, start_index)
   fill_in_blocked(array, gen_random_b64(blocked_count))
   return end_index, array


if __name__ == '__main__':
    board_set = []
    with open('chess/boards', 'r') as boards:
        full = boards.read()
        a_boards = full.split('x'*13)
        for single in a_boards:
            actual =  single.split('\n')
            board_set.append(actual)
    
    genned = []

    payload = None
    with open('flag.test','rb') as flagfile:
        payload = base64.b64encode(flagfile.read())
    
    payload = str(payload)[1:].replace("'","")
    
    payload = payload + payload
    pay_ind = 0 
    for i in range(1, len(board_set)-1):
        cur = board_set[i]
        pay_ind, arr = full_payload(cur, payload, pay_ind) 
        genned.append("\n".join(["".join(row) for row in arr]))
    
    print('writing') 
    with open('gboards', 'w') as board_out:
        board_out.write("\n".join(genned))
