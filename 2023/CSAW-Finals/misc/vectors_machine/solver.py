import random
from sklearn.linear_model import LinearRegression
from pwn import *
from tqdm import tqdm
context.log_level= "warn"

def model(x):
    #p = process("./chal.py")
    p = remote("localhost", 12312)
   
    for i in range(2):
        p.sendlineafter(b"Enter your input: ", bytes(str(x[i]), 'utf-8'))
        #p.sendlineafter(b"Enter your input: ", str(x[i]))
    
    p.recvuntil(b"Calculating. . .\r\n")
    res = p.recvline()
    p.close()
    if res == b"Cool numbers! :)\r\n":
        return 1
    else:
        return -1

# For quicker calculations instead of running a program or connecting remotely.
# def model(x):
#     w1 = 78488453.8580
#     w2 = 1
#     b = 80488255.5168
#     total = (w1*x[0]) + (w2*x[1]) + b
#     if total < 0:
#         return -1
#     else:
#         return 1

# Finds the midpoint closest to svm boundary.
def find_line(loop, p1, p2):
    def midpoint(p1, p2):
        mid = []
        if len(p1) != len(p2):
            raise Exception("The two points are not in the same Dimensions!")
        for i, val in enumerate(p1):
            mid.append((val + p2[i])/2)
        return mid

    mid = midpoint(p1, p2)
    points = [p1, mid, p2]
    midpoints = [mid]
    for i in range(loop):
        pred = model(mid)
        if pred == -1:
            points[0] = mid
            mid = midpoint(mid, points[2])
        else:
            points[2] = mid
            mid = midpoint(mid, points[0])
        points[1] = mid
        midpoints.append(mid)
    return mid, midpoints

# Finds 2 points that are classified differently and the aggressive midpoint close to the svm boundary.
def find_2class(a,b):
    points = []
    for i in tqdm(range(15)):

        p1 = [random.randint(0,b), random.randint(0,b)]
        p2 = [random.randint(a,0), random.randint(a,0)]
  
        p1_pred = model(p1)
        p2_pred = model(p2)
        
        while p1_pred == p2_pred:
            p1 = [random.randint(0,b), random.randint(0,b)]
            p2 = [random.randint(a,0), random.randint(a,0)]

            p1_pred = model(p1)
            p2_pred = model(p2)
            print(p1, p1_pred, p2, p2_pred)
    
        if p1_pred == -1:
            points.append(find_line(1000, p1, p2)[0])
        else:
            points.append(find_line(1000, p2, p1)[0])
    return points

# Let's use big bounds to find a bunch of points that are close to the svm boundary.
points = find_2class(-10000000,100000000)

# Take these points and use Linear Regression to make the line
X1 = []
X2 = []
for i in points:
    X1.append([i[0]])
    X2.append(i[1])
steal = LinearRegression()
steal.fit(X1,X2)

print(steal.coef_[0], steal.intercept_)
# Stringify the two numbers and convert to ascii. 
# Note: Every two numbers is ascii. 
first_part = round(-1 * float(steal.coef_[0]) * 10**4)
second_part = round(-1 * float(steal.intercept_) * 10**4)
both = str(first_part) + str(second_part)

lst = [chr(int(x)) for x in [both[i]+both[i+1] for i in range(0,len(both),2)]]
print(lst)
flag = ''.join(lst)

print("csawctf{"+flag+"}")

    