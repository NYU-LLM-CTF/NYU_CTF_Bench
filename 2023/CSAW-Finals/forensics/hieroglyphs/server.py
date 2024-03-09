#! /usr/bin/python3

import random, hashlib

def check_answer(check):
    while True:
        print("Please enter your answer:", end='')
        answer = input()
        if answer == check:
            print("Correct!")
            break
        else:
            print("Not exactly, try again later")
            exit()

def proof_of_work():
    difficulty = 28 # CHANGE THIS
    while True:
        nonce = random.randint(1000000000, 9999999999) #10 digit random number
        nonce = str(nonce)
        print("Proof of work requires " + str(difficulty) + " leading 0 bits in the sha256 hash")
        print("Your input is:" + nonce)
        print("Your calculated proof of work response is:", end='')
        response = input().strip()
        if check_response(nonce + response, difficulty):
            print("Passed!")
            break
        else:
            print("Failed!, try again!")

def check_response(combo, difficulty):
    a = hashlib.sha256()
    a.update(combo.encode())
    hashed = a.hexdigest()
    for i in range(difficulty//4):
        if hashed[i] != "0":
            return False
    return True

if __name__ == "__main__":
    print("Who is named by these hieroglyphs?")
    proof_of_work()
    check_answer("Hatshepsut")
    flag_file = open("flag.txt", "r")
    flag = flag_file.read()
    print(f"Congratulations! Here's your flag --> " + flag)
    flag_file.close()
