scramble = """
              B Y Y
              Y O B
              W G G
B R O  W G O  G R O  Y W O
W B G  W Y R  W G Y  O W O
R B R  Y B W  B Y R  B G W
              R B Y
              R R O
              G O G
"""
scramble = """
              B G W
              Y R O
              R G B
G Y Y  O R W  G R O  W Y O
G W W  R G Y  B Y W  O B O
R R B  R O Y  O G R  B W G
              G W Y
              B O B
              W B Y
"""



corect_order = ["UF", "UR", "UB", "UL", "DF", "DR", "DB","DL", "FR", "FL","BR","BL","UFR","URB","UBL","ULF","DRF","DFL","DLB","DBR"]

cube = scramble.split()

other = cube[9:-9]

top = other[:12]
middle = other[12:24]
bottom = other[24::]

colors = {"G":"F", "W":"R", "Y":"L", "B":"B", "O":"U", "R" : "D"}


B = top[:3] + middle[:3] + bottom[:3]
L = top[3:6] + middle[3:6] + bottom[3:6]
F = top[6:9] + middle[6:9] + bottom[6:9]
R = top[9::] + middle[9::] + bottom[9::]
U = cube[0:9]
D = cube[-9::]

faces = [B,L,F,R,U,D]
for i in faces:
    for j in range(9):
        i[j] = colors[i[j]]

mapp = {"UF": U[7]+F[1], "FU": F[1] + U[7], "UR": U[5]+R[1], "RU": R[1] + U[5], "UB" : U[1]+B[1], "UL" : U[3] + L[1], "LU":L[1]+U[3],"DF" : D[1] + F[7], "FD":F[7]+D[1], "DR" : D[5] + R[7], "RD":R[7]+D[5],
        "DL" : D[3]+L[7], "LD" : L[7] + D[3], "DB" : D[7] + B[7], "FR" : F[5]+R[3], "RF" : R[3] + F[5], "FL" : F[3] + L[5], "LF":L[5]+F[3],"BR" : B[3]+R[5], "BL" : B[5]+L[3], "UFR":U[8]+F[2]+R[0], "RUF":R[0]+U[8]+F[2],"FRU":F[2]+R[0]+U[8],"URB":U[2]+R[2]+B[0], "RBU":R[2]+B[0]+U[2],"BUR":B[0]+U[2]+R[2],"UBL": U[0]+B[2]+L[0], "BLU":B[2]+L[0]+U[0], "LUB":L[0]+U[0]+B[2],
        "ULF" : U[6] + L[2] +F[0], "LFU":L[2]+F[0]+U[6],"FUL":F[0]+U[6]+L[2],"DRF":D[2]+R[6]+F[8], "FDR":F[8]+D[2]+R[6],"DFL" : D[0]+F[6]+L[8], "FLD":F[6]+L[8]+D[0],"DLB" : D[6]+L[6]+B[8], "LBD":L[6]+B[8]+D[6],"DBR" : D[8]+B[6]+R[8], "BRD":B[6]+R[8]+D[8]}    




sample = ""
for i in corect_order:
    sample += mapp[i]
    sample += " "

print(sample)


#mapp = {v: k for k, v in mapp.items()}


#    O
#B Y G W
#    R


rondom  = """
              R B Y
              G Y R
              R W Y
B R Y  B Y W  G B R  G W O
W B G  R R B  O G B  Y O O
G R R  W G W  G O B  W W O
              O Y O
              O W G
              B Y Y
"""
# X'
rondom  = """
              B G W
              W R O
              Y G B
G Y W  R R O  B R O  W Y O
G W B  O G R  Y Y W  O B O
R R G  Y Y W  R G R  B W G
              G W Y
              B O B
              O B Y
"""



cube = rondom.split()

other = cube[9:-9]

top = other[:12]
middle = other[12:24]
bottom = other[24::]

B = top[:3] + middle[:3] + bottom[:3]
L = top[3:6] + middle[3:6] + bottom[3:6]
F = top[6:9] + middle[6:9] + bottom[6:9]
R = top[9::] + middle[9::] + bottom[9::]
U = cube[0:9]
D = cube[-9::]

faces = [B,L,F,R,U,D]
for i in faces:
    for j in range(9):
        i[j] = colors[i[j]]

mappp = {"UF": U[7]+F[1], "FU": F[1] + U[7], "UR": U[5]+R[1], "RU": R[1] + U[5], "UB" : U[1]+B[1], "UL" : U[3] + L[1], "DF" : D[1] + F[7], "FD":F[7]+D[1], "DR" : D[5] + R[7], 
        "DL" : D[3]+L[7], "LD" : L[7] + D[3], "DB" : D[7] + B[7], "FR" : F[5]+R[3], "RF" : R[3] + F[5], "FL" : F[3] + L[5], "BR" : B[3]+R[5], "BL" : B[5]+L[3], "UFR":U[8]+F[2]+R[0], "RUF":R[0]+U[8]+F[2],"URB":U[2]+R[2]+B[0], "RBU":R[2]+B[0]+U[2],"UBL": U[0]+B[2]+L[0], "BLU":B[2]+L[0]+U[0],
        "ULF" : U[6] + L[2] +F[0], "LFU":L[2]+F[0]+U[6],"DRF":D[2]+R[6]+F[8], "DFL" : D[0]+F[6]+L[8], "DLB" : D[6]+L[6]+B[8], "DBR" : D[8]+B[6]+R[8]}    


sample = ""
for i in corect_order:
    sample += mappp[i]
    sample += " "



solve =""
for i in sample.split():
    solve += mapp[i]
    solve+=" "

