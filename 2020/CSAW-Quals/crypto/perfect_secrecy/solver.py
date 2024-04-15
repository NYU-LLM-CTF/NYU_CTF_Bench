'''
One time pad does not satisfy perfect secrecy if the key is reused.
Both images have been xored with the same key.
image1 = flag xor key
image2 = other xor key
So image1 xor image2 = flag xor other, which reveals the flag
'''

from PIL import Image, ImageChops
import base64
im1 = Image.open(r"image1.png") .convert("1")
im2 = Image.open(r"image2.png") .convert("1")

im3 = ImageChops.logical_xor(im1,im2)
im3.show()

# Displays an image containing base64 encoded flag

flag = base64.b64decode("ZmxhZ3swbjNfdDFtM19QQGQhfQ==").decode("utf-8")

print(flag)