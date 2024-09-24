#### Details

This is a challenge about MSB or LSB leakage of state output in prng.

The relationship of the state is:
$$x_i = a_0 x_{i-1}+a_1x_{i-2}\pmod {n_1}$$
$$y_i = b_0 y_{i-1}+b_1y_{i-2}\pmod {n_2}$$
$$z_i=x_i-y_i\pmod {n_1}$$
And the challenge leaks $I = beta\cdot modulebit$ bits (maybe LSBs of $x_i$ , MSBs of $z_i$) ...Then use the next $y_i$ to encrypt the flag.

#### Solution

Firstly, we can find it just like HNP(about $x_i$).
$$x_i = a_0 x_{i-1}+a_1x_{i-2}\pmod {n_1}$$
$$\text{So  }\ \ \ 0 =-x_{ih} +  a_0 x_{(i-1)h}+a_1x_{(i-2)h} + (a_0x_{(i-1)l}+a_1x_{(i-2)l} - x_{il})/2^{beta\cdot modulebit}\pmod {n_1}$$

Then we build a Lattice $\mathcal{L_x}$ , and we denote $\mathcal{LL_x}$ as the LLL-reduction of $\mathcal{L_x}$. And we denote $X_is$ as the constant coefficients here, such as $X_0 = (a_0x_{1l}+a_1x_{0l} - x_{2l})/2^{beta\cdot modulebit}$.

$$\mathcal{L_x} = 
\begin{bmatrix}
1&&&&&&a_1 \\
&1&&&&&a_0&a_1 \\
&&1&&&&-1&a_0&a_1 \\
&&&1&&&&-1&a_0 \\
&&&&1&&&&-1 \\
&&&&&2^{beta\cdot modulebit}&X_0&X_1&X_2 \\
&&&&&&n_1 \\
&&&&&&&n_1 \\
&&&&&&&&n_1
\end{bmatrix}$$

We can get $(x_{0h},x_{1h},x_{2h},x_{3h})$ when the 6th argument in a row of $\mathcal{LL_x}$ is $2^{beta\cdot modulebit}$ and the 7th,8th arguments are 0. Then $xs$ can be recovered.



Next, we denote $alpha+beta=1$, then
$$z_{ih}\cdot 2^{modules\cdot alpha}+z_{il} = x_i-y_i\pmod {n_1}$$
$$y_i =x_i - z_{ih}\cdot 2^{modules\cdot alpha} - z_{il} \pmod {n_1}$$

so

$$y_i = b_0 y_{i-1}+b_1y_{i-2}\pmod {n_2}$$

$$y_{ih}\cdot 2^{module\cdot alpha} + y_{il} = b_0(y_{(i-1)h}\cdot 2^{module\cdot alpha} + y_{(i-1)l})+b_1(y_{(i-2)h}\cdot 2^{module\cdot alpha} + y_{(i-2)l})\pmod {n_2}$$

$$b_0y_{(i-1)l}+b_1y_{(i-2)l}-y_{il} - (y_{ih}\cdot 2^{module\cdot alpha}-b_0y_{(i-1)h}\cdot 2^{module\cdot alpha}-b_1y_{(i-2)h}\cdot 2^{module\cdot alpha})=0\pmod {n_2}$$

And we can get approximately $ys$ from $x_i - z_{ih}\cdot 2^{modules\cdot alpha}\pmod {n_1}$ . We denote the constant coefficients as $Y_is$. Build a Lattice $\mathcal{L_y}$

$$\mathcal{L_y}=
\left[\begin{matrix}
1&&&&&&b_1\\
&1&&&&&b_0&b_1\\
&&1&&&&-1&b_0&b_1\\
&&&1&&&&-1&b_0\\
&&&&1&&&&-1\\
&&&&&2^{beta\cdot modulebit}&Y_0&Y_1&Y_2\\
&&&&&&n_2\\
&&&&&&&n_2\\
&&&&&&&&n_2
\end{matrix}\right]$$

Then, we can use the same method as getting $x_s$ to get the exact $y_s$. Next, we can forecast next $y_i$ to recover flag.
