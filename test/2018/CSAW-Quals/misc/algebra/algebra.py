#!/usr/bin/env python3.6
import operator
from random import randint, choice

operators = {
    "*": operator.mul,
    "+": operator.add,
    "-": operator.sub,
    #"/": operator.truediv
}

def generate_expr():
    return f"{randint(1,20)} {choice(list(operators.keys()))} {randint(1,20)}"

def generate_alg_eq():
    if randint(0,1) == 0:
        return f"{randint(1,20)} {choice(list(operators.keys()))} X = {randint(11,156)}"
    else:
        return f"X {choice(list(operators.keys()))} {randint(1,20)} = {randint(11,156)}"

def generate_compound(n = 0, expr1 = None, expr2=None):
    if expr1 is None:
        expr1 = generate_expr()
    if expr2 is None:
        expr2 = generate_expr()
    if n != 0:
        return f"({generate_compound(n - 1, generate_compound(n-1), generate_compound(n-1))}) {choice(list(operators.keys()))} ({generate_compound(n - 1, generate_compound(n-1), generate_compound(n-1))})"

    return f"({expr1}) {choice(list(operators.keys()))} ({expr2})"

def generate_compound_eq(n):
    eq = generate_compound(n)
    fin = eval(eq)
    comp = list(eq)
    num = 0
    for i,v in enumerate(comp):
        if v.isdigit():
           num += 1
        if num == 3:
            comp[i] = "X"
            if comp[i+1].isdigit():
                comp[i+1] = ""
            if comp[i-1].isdigit():
                comp[i-1] = ""
            break
    
    return "".join(comp) + f" = {fin}"


def accept_answer(equ):
    exp, fin = equ.split(" = ")

    print(equ)

    ans = input("What does X equal?: ")
    try:
        float(ans)
    except:
        print("HEYYYY THAT IS NOT VALID INPUT REMEMBER WE ONLY ACCEPT DECIMALS!")
        exit()

    exp = exp.replace("X", ans)
    #print(exp)
    #print(abs(eval(exp) - int(fin.strip()))) 
    if abs(eval(exp) - int(fin.strip())) <= .75:
        print("YAAAAAY keep going")
    else:
        print("Sorry Try Again ):")
        exit()

if __name__ == "__main__":
    for i in range(25):
        accept_answer(generate_alg_eq())

    for i in range(25):
        accept_answer(generate_compound_eq(2))
    
    for i in range(25):
        accept_answer(generate_compound_eq(3))
    
    for i in range(25):
        accept_answer(generate_compound_eq(4))

    with open("flag.txt","r") as flag:
        print(flag.read())
