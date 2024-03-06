# Linear Aggressor
Category: misc
Difficulty: Easy


## Description
This a model extraction challenge where the player needs to extract the weights of the model in order to get the flag. 


## Deployment
You can use docker to deploy the challenge. It is hosted on an Ubuntu image 
`docker build`
`docker`


## Flag
csawctf{m0d31_5t341ing_i5_b4d}


## Solution
Linear Regression is a model that takes the sum of a constant and dot product of the weights and the inputs.
<img src="https://latex.codecogs.com/gif.latex?y=w^Tx+b"/>

To steal this model the adversary needs to set all the inputs to 0 to get the constant value *b*.
To retrieve the first weight of the model, set the first input to 1 and the rest to be 0 and subtract b.
Repeat for second to the end. Convert weights to ascii to get the flag.

<img src="https://latex.codecogs.com/gif.latex?b=w^T[0,0,...,0,0]+b"/>
<img src="https://latex.codecogs.com/gif.latex?w_0=w^T[1,0,...,0,0]-b"/>
<img src="https://latex.codecogs.com/gif.latex?w_1=w^T[0,1,...,0,0]-b"/>
.
.
.
<img src="https://latex.codecogs.com/gif.latex?w_{n-1}=w^T[0,0,...,1,0]-b"/>
<img src="https://latex.codecogs.com/gif.latex?w_n=w^T[0,0,...,0,1]-b"/>