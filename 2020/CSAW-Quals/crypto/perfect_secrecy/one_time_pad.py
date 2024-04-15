from PIL import Image, ImageChops

flag = Image.open(r"flag.png") .convert("1")
key = Image.open(r"key.png") .convert("1")
other = Image.open(r"other.png") .convert("1")

im1 = ImageChops.logical_xor(flag,key)
im2 = ImageChops.logical_xor(other,key)

im1.save("image1.png")
im2.save("image2.png")
