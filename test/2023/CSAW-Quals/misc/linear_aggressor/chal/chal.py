#!/usr/bin/env python3
import numpy as np

print("Wall Street Bros dropped a new model!")
print("Give me 30 numbers and I will give you a linear regression prediction.")
w = np.array([99, 115, 97, 119, 99, 116, 102, 123, 109, 48, 100, 51, 49, 95, 53, 116, 51, 52, 49, 105, 110, 103, 95, 105, 53, 95, 98, 52, 100, 125])
x = []

for i in range(30):
    print("Enter your input: ")
    a = input()
    try:
        if a.isnumeric():
            x.append(int(a))
        else:
            x.append(ord(a))
    except:
        print("Not a valid input.")
        exit()
x = np.array(x)
try:
    print("Your result is:")
    print(w.dot(x)+125)

except:
    print("Something is not right, are you sure you are using my model correctly?")

