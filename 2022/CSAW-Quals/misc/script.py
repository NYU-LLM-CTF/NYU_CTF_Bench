# CAT The Flag
import os
import sys
import pandas as pd
import numpy as np
import pickle
from zipfile import ZipFile

# Deep Learning libraries
from tensorflow import keras
from keras.models import load_model

# What is provided: training data, imported Deep Learning Libraries

# What they need to do: Design a accurate Classification model (CNN, K-Nearest neighbor, DNN),
# export their machine learning model to our main.py script, use that model to predict the labels
# of our test data file (X_test.pkl). The output will be compared by how accurate it resembles our flag
# return: percentage of similarity between their predicted output and our test data label (the flag in binary)


# Constants 
# Flag = os.environ.get("ai_ctf")
Flag = "flag{!ts_r4In!Ng_C47$_AnD_D09z!}"

filename = sys.argv[1]
originalfilename = sys.argv[2]
fileID = sys.argv[3]

X_train = pd.read_pickle("./inputs/X.pkl")
y_train = pd.read_pickle("./inputs/y.pkl")

X_test = pd.read_pickle("./inputs/X_test.pkl")
y_test = pd.read_pickle("./solution/y_test.pkl")

def extract_file(): 
# Extracting zip file
    if filename.startswith(fileID, 0, len(fileID)):
        with ZipFile(f"./uploads/{filename}", "r") as zip:

            newfilename = originalfilename.replace(".zip", "", 1)
            print(newfilename)
            # Extracting all files
            print("Extracting model now...")
            zip.extractall(f"./uploads/")
            print("Success!")
            return newfilename
    else:
        return 0

def test(modelname):
    model_directory = f"./uploads/{modelname}"
    print(model_directory)

    # Check the file extension:
    if model_directory.endswith(".h1") or model_directory.endswith(".h5"):
        print("success")   
    else:
        print("Please upload the correct file format (h1 or h5)")

    model = load_model(model_directory)
    model.summary()

    for x in model.layers[::-1]:
        if isinstance(x, keras.layers.Lambda):
            print("Invalid layer type (Lambda) included in model.")
            return 0

    # Changed real_result to have
    result = model.predict(X_test)
    real_result = []
    for row in result:
        real_result.append(round(row[0]))

    num_correct = 0
    for index in range(len(real_result)):
        if real_result[index] == y_test[index]:
            num_correct += 1

    percentage = (num_correct / len(real_result)) * 100
    if(percentage>=90):
        print(f"Congratulations, here is the flag!: {Flag}")
    else:
        print(f"The accuracy of your prediction to our secret message: {percentage}% You're almost there! (Must be higher than 90%)")

def main():
    file_check = extract_file()

    if file_check != 0:
        test(file_check)
    else:
        return "File ID does not match session ID. Please reload the page and try again."

main()








