# https://jeremykun.com/2014/11/18/learning-a-single-variable-polynomial-or-the-power-of-adaptive-queries/

a = 2669
b = 457872149190039938449409450797259650244955817397381468272138729997481631896039607738236

ans = []
while b:
    remainder = b % a
    ans.append(remainder)
    b = (b - remainder) // a

print("".join(map(chr, ans)))
