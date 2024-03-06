import pickle
# Deep Learning libraries
from keras.models import Sequential
from keras.layers import Conv2D, MaxPooling2D, Flatten, Dense

#Changed this to 

X = pickle.load(open('/Users/mahmoudshabana/Documents/School/NYU/OSIRIS/CSAW-CTF-2022/CSAW-CTF-2022-Quals/misc/AI-CTF/CatTheFlag/inputs/X.pkl', 'rb'))
y = pickle.load(open('/Users/mahmoudshabana/Documents/School/NYU/OSIRIS/CSAW-CTF-2022/CSAW-CTF-2022-Quals/misc/AI-CTF/CatTheFlag/inputs/y.pkl', 'rb'))

# X = X.astype('float32')
X = X / 255
print(len(X))

model = Sequential()

model.add(Conv2D(64, (3,3), activation = 'relu'))
# model.add(BatchNormalization())
model.add(MaxPooling2D(2,2))
# model.add(Dropout(0.10))

model.add(Conv2D(64, (3,3), activation = 'relu'))
# model.add(BatchNormalization())
model.add(MaxPooling2D(2,2))
# model.add(Dropout(0.10))


model.add(Flatten())
model.add(Dense(128, input_shape = X.shape[1:], activation = 'relu')) # shape of image (100, 100, 3)

# The final layer has a single node- this final node uses the sigmoid activation function as we're conducting binary classificaiton 
# Binary classfication problems: The final layer (output layer of the neural network should have one node) 
model.add(Dense(1, activation = 'sigmoid')) # output NN

# Binary cross-entropy is for binary classification 
model.compile(optimizer = 'adam', loss = 'binary_crossentropy', metrics=['accuracy'])

model.fit(X, y, epochs = 13, validation_split = 0.1)

# 74 Batches = (2610 - (2610 * 0.1)) / 32 (32 is default batch)
# 261 images for validation = 2610 * 0.1

model.save("CNN_model.h1") 

