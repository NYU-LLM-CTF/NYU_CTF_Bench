#!/usr/bin/env python3

def model(x):
    w1 = 78488453.8580
    w2 = 1
    b = 80488255.5168
    total = (w1*x[0]) + (w2*x[1]) + b
    if total < 0:
        return -1
    else:
        return 1

def main():
    print("Welcome to Vector's Machine!")
    print("I drew one line to seperate the cool and not cool numbers.")
    print("Give me 2 numbers and I will tell you if they are cool or not!")

    x = []

    for i in range(2):
        print("Enter your input: ")
        a = input()
        try:
            x.append(float(a))
        except:
            print("Not a valid input.")
            quit()

    print("Calculating. . .")
    result = model(x)

    if result == 1:
        print("Cool numbers! :)")
    else:
        print("Not cool numbers! >:(")

main()

# csawctf{N0T5UPP0R73D}