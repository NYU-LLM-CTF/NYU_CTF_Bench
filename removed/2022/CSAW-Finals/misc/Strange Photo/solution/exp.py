import torch
import torch.nn as nn
import torch.nn.functional as func
import torchvision.transforms as transforms
from PIL import Image
import numpy as np
from torch.utils.data import Dataset,DataLoader
import os
import cv2

if os.path.exists('./tmpblocks/')==False:
    os.mkdir('./tmpblocks/')

if os.path.exists('./tmpdiff/')==False:
    os.mkdir('./tmpdiff/')

if os.path.exists('./tmpmask/')==False:
    os.mkdir('./tmpmask/')

if os.path.exists('./tmpflag/')==False:
    os.mkdir('./tmpflag/')

img0=np.array(Image.open('./diff.jpg'))
img2=np.array(Image.open('./single.jpg'))

picsize=28
h=3*5*28*3
numh=3*5*3
w=3*6*28*3
numw=3*6*3
cnt=0
for i in range(0,h,picsize):
    for j in range(0,w,picsize):
        tmpimg=img2[i:i+picsize,j:j+picsize]
        cv2.imwrite('./tmpblocks/'+str(cnt)+'.jpg',tmpimg)
        cnt+=1
cnt=0
for i in range(0,h,picsize):
    for j in range(0,w,picsize):
        tmpimg=img0[i:i+picsize,j:j+picsize]
        cv2.imwrite('./tmpdiff/'+str(cnt)+'.jpg',tmpimg)
        cnt+=1
print(cnt)

class Mask(nn.Module):

    def __init__(self):
        super(Mask, self).__init__()
        self.conv1 = nn.Conv2d(1, 6, 5)
        self.conv2 = nn.Conv2d(6, 16, 5)
        self.linear1 = nn.Linear(256, 784)

    def forward(self, x):
        x = func.relu(self.conv1(x))
        x = func.max_pool2d(x, 2)
        x = func.relu(self.conv2(x))
        x = func.max_pool2d(x, 2)
        x = x.view(x.size(0), -1)
        x = func.relu(self.linear1(x)).reshape((28,28)).tolist()
        for i in range(28):
            for j in range(28):
                x[i][j] = int(x[i][j] * 255)
                if (x[i][j] > 255):
                    x[i][j] = 255
        return x

class MyDataSet(Dataset):
    def __init__(self,datapath):
        self.datapath=datapath
        self.trans=transforms.Compose([transforms.ToTensor()])
        self.data=list()
        imgname=os.listdir(datapath)
        imgnum=len(imgname)
        for i in range(imgnum):
            img=Image.open(datapath+str(i)+'.jpg')
            self.data.append(transforms.ToTensor()(img))

    def __len__(self):
        return len(self.data)

    def __getitem__(self, item):
        return self.data[item]

batchsize=1
train=DataLoader(MyDataSet('./tmpblocks/'),batch_size=batchsize,shuffle=False,drop_last=False)
model=torch.load('./Mask.pt')

piclen=28
targetimg=np.zeros(h*w).astype('int')
for k, data in enumerate(train):
    inputs=data.cuda()
    img=model(inputs)
    img=np.array(img)
    Image.fromarray(img).convert('L').save('./tmpmask/' + str(k) + '.jpg')

imgnum=cnt
flag_path='./tmpflag/'
mask_path='./tmpmask/'
diff_path='./tmpdiff/'
for i in range(imgnum):
    tmpimg0=np.array(Image.open(diff_path+str(i)+'.jpg'))
    tmpimg1=np.array(Image.open(mask_path+str(i)+'.jpg'))
    tmpimg2=np.zeros((piclen,piclen))
    for j in range(piclen):
        for k in range(piclen):
            tmpimg2[j][k]=tmpimg0[j][k]^tmpimg1[j][k]
    Image.fromarray(tmpimg2).convert('L').save(flag_path+str(i)+'.jpg')

img_h=3*5*3*28
img_w=3*6*3*28
img_mask=np.zeros((img_h,img_w))
img_num=0
for i in range(img_h//28):
    for j in range(img_w//28):
        tmpimg=np.array(Image.open(flag_path+str(img_num)+'.jpg'))
        img_num+=1
        for k in range(28):
            for l in range(28):
                img_mask[i*28+k][j*28+l]=tmpimg[k][l]
Image.fromarray(img_mask).convert('L').save('./flags.jpg')

