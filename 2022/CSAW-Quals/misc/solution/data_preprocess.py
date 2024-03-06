import numpy as np
import cv2 # pip install opencv-python 
import os
import random
import matplotlib.pyplot as plt # data visualization
import pickle # save our data
import zipfile

# Only run if you have a zipped dataset
# zip_ref = zipfile.ZipFile("/Users/mahmoudshabana/Documents/School/NYU/OSIRIS/CSAW-CTF-2022/CSAW-CTF-2022-Quals/misc/AI-CTF/PetImages.zip", "r")
# zip_ref.extractall("/Users/mahmoudshabana/Documents/School/NYU/OSIRIS/CSAW-CTF-2022/CSAW-CTF-2022-Quals/misc/AI-CTF/PetImages")
# zip_ref.close()

# Get Path to dataset
DIRECTORY = "/Users/EthanSam/Documents/GitHub/CSAW-CTF-2022-Quals/misc/AI-CTF/PetImages"
CATEGORIES = ["Cat", "Dog"]

# Need a uniform image size to train the model
IMG_SIZE = 80 # too small of an image size can effect the models accuracy

data = []

for category in CATEGORIES:
  folder = os.path.join(DIRECTORY, category)
  label = CATEGORIES.index(category)
  for img in os.listdir(folder):
    # get path of each image
    img_path = os.path.join(folder, img)
    
    # give path to cv2 so img can be converted into an array
    img_arr = cv2.imread(img_path)
    if img_arr is not None:
      # print(img_arr)
      img_arr = cv2.resize(img_arr, (IMG_SIZE, IMG_SIZE))
    else:
      break

    data.append([img_arr, label])

# We need to shuffle our data array (Optional and can be omitted)
random.shuffle(data)

binary_string = "01000011 01010011 01000001 01010111 01011111 01000011 01010100 01000110 01111011 00100001 01110100 01110011 01011111 01110010 00110100 01001001 01101110 00100001 01001110 01100111 01011111 01000011 00110100 00110111 00100100 01011111 01000001 01101110 01000100 01011111 01000100 00110000 00111001 01111010 00100001 01111101"
new_img_data = []

new_cat_data = [[features, labels] for features, labels in data if labels == 0]
new_dog_data = [[features, labels] for features, labels in data if labels == 1]

for char in binary_string:
    if char == " ":
        continue
    elif char == "0":
        new_img_data.append(random.choice(new_cat_data))
    elif char == "1":
        new_img_data.append(random.choice(new_dog_data))
        

# Seperate the feature array with the label into two seperate variables
X = []
y = []

for features, labels in data:
  X.append(features)
  y.append(labels)

X_test = []
y_test = []

for features, labels in new_img_data:
    X_test.append(features)
    y_test.append(labels)

# convert our lists into arrays using numpy (must save to pickle file)
X = np.array(X)
y = np.array(y)

X_test = np.array(X_test)
y_test = np.array(y_test)


pickle.dump(X, open('X.pkl', 'wb'))
pickle.dump(y, open('y.pkl', 'wb'))

pickle.dump(X_test, open('X_test.pkl', 'wb'))
pickle.dump(y_test, open('y_test.pkl', 'wb'))

# Flag = "CSAW_CTF{!ts_r4In!Ng_C47$_AnD_D09z!}"