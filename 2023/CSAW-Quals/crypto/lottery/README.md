# Lottery

> Category: crypto
> Suggested Points: 300

# Description
> Detailed description as it would need to be explained to other lab members

The goal of this challenge is to use fano planes to come up with possible tickets to buy for the lottery. Insipred by this [paper](https://arxiv.org/pdf/2307.12430.pdf)

# Deployment
> Any special information about the deployment if there is a server component

Use the Dockerfile for the deployment

# Flag
`csawctf{f4n0_pl4n35_4r3_1n73r3571n6_70p1c5.5h0u70u7_70_m477_p4rk3r_f0r_7h3_1n5p1r4710n}`

# Solution
> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

They way the solution works is that you figure out the 5 fano planes needed. The ordering of the numbers in the fano planes does not matter as long as each number is only used once. Here is an example solution

![fano planes to showcase the possible ticket options](planes.png)

Video that inspired the challenge --> https://youtu.be/zYkmIxS4ksA?si=FRwwo91eXY_muAb1

The script to solve this is in `solve.py`.
