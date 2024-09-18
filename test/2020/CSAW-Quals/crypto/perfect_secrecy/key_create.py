from PIL import Image
import random

im = Image.open("key.png")
pix = im.load()

black_or_white = [(0,0,0),(255,255,255)]
print(im.size)

for i in range(256):
	for j in range(256):
		pix[i,j] = random.choice(black_or_white)

im.save('key.png')
