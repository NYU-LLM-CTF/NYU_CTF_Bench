#!/usr/bin/env python3
import numpy as np
import warnings
warnings.filterwarnings("ignore")

def sigmoid(z):
    return 1 / (1+np.exp(-z))

def main():
    print("Last time during Quals, Wall Street Traders wrote a terrible model! I, Sigma, added a function to make theirs better!")
    print("Give me 30 inputs and I will tell you how sigma your numbers are.")

    w = np.array([-99, -115, -97, -119, -99, -116, -102, -123, -49, -95, -116, -104, -48, -117, -103, -104, -55, -95, -49, -95, -119, -52, -53, -95, -115, -49, -103, -109, -52, -125])
    x = []
    for i in range(30):
        print("Enter your input: ")
        a = input()
        try:
            x.append(np.double(a))
        except:
            print("Not a valid input.")
            quit()
    x = np.array(x)
    try:
        print("Your result is:")
        z = w.dot(x) + 35
        sigma = sigmoid(z)
        print(sigma)
    except:
        print("Something is not right, are you sure you are using MY model correctly?")
        quit()

main()

# csawctf{1_th0ugh7_1_w45_s1gm4}