import qrcode

FLAG = "flag{tH3_5chw1fTy_C0n3teLat10N}"
# parameters - length scale: parsecs? : speed of network ~ speed of light?
H = 1
C = 1

# we have a N x N grid (N = 25)  and M points on it are the satelites (321)
# Unknown vars? Pairwise distances: D[i,j] , |..| ~ M*(M-1)/2 
# Make this an (under/over)constrained system & BAM!
# Order of magnitude of messages we would need?

# EASY VERSION: 2D constellation
# HARD VERSION: 3D constellation, the points don't lie on a plane
# CHRIS NOLAN VERSION: satelites live in a 4D world, on each projection to 2D we get 1 QR code or something...

qr = qrcode.QRCode(
    version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_L,
    box_size=10,
    border=4,
)
qr.add_data(FLAG)
qr.make(fit=True)

img = qr.make_image(fill_color="black", back_color="white")
qr.border = 0
mat = qr.get_matrix()
N = len(mat)
M = 0
print("dat = [",end="")
for i,row in enumerate(mat):
    for j,c in enumerate(row):
        if c:
            M += 1
            print(f"( {i}, {j}), ",end="")
print("]")
print(f"{N} | {M}")


iptbl = []
# each packet is going to be (SRC_IP, DST_IP, TIME_IT_TOOK)
packets = []

# importing cv2 
import cv2 
import numpy as np
DH = 8
XDH = 2*DH
img2 = np.zeros((50*DH,50*DH,1),np.uint8)  
# img_ = cv2. 
for i in range(N):
    for j in range(N):
        if mat[i][j]:
            cv2.rectangle(img2,(i*XDH,j*XDH),(i*XDH+DH//3,j*XDH+DH//3),255,cv2.FILLED)
cv2.imshow('image',img2)
cv2.waitKey(0)
cv2.destroyAllWindows()