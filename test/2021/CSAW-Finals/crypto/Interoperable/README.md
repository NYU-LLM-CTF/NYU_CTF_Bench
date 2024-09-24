# Interoperable

## Author

Cryptohack (jack)

## Description

Let's use standard curves to ensure interoperability.

## Distribution to players

- `chal.py` --> md5: cef098879f5f20c1f1ee8bc1cfcab43e

## Deploying

See `Dockerfile`

## Solution

This challenge is a classic example of an _invalid point attack_. The user is asked to solve the discrete log problem on either the NIST P256 curve, `secp256r1`, or the Bitcoin curve `secp256k1`. Both of these curves have prime order ~ 2^{256} in size, with a bit security of 128 bits. As a result, attempting to solve the discrete log on either of these curves is totally infeasible. 

The challenge is solvable because of a vulnreability in how we allow the user to pick a generator and curve. The intended solution is as follows:

- The user selects the curve `secp256k1` by sending `{"curve" : "curve_s256"}`
- The user then sends a random point which is defined on `secp256k1`. The format for sending a point as the generator requires the user to send the `x,y` coordinates as hex strings: `{"Gx" : hex(Px), "Gy" : hex(Py)}`
- Before continuing, the user then changes the curve to `secp256r1` by sending `{"curve" : "curve_p256"}`.
- The point `G` is not defined on `secp256r1` and from the perspective of the curve equation we have:

$$
E : y^2 - x^3 - Ax - B = C !=0
$$

As the elliptic curve arithmetic is independent of the parameter `B` we can essentially think of this point as being defined on the new curve

$$
E' : y^2 - x^3 - Ax - B' = 0
$$

where `B' = B - C`. 

- This new curve will have the point `G` with a order not equal to that of the `secp256r1` curve, and if we carefully select `G`, we can find ourselves in a situation where `G.order()` is a composite integer with many small factors.
- The bit-security of the discrete log problem for an elliptic curve is bounded by the size of the largest prime factor of the order. 
- The user should pick random points `G` defined on the Bitcoin curve. Each random point will produce a new curve `E'`, and by checking the factorisation of the order of `G`, a weak curve can be found
- For example, the point:

```
Gx = 0x9d80c0d5fadc37cd6bd6a8a227060347b22759b99e651e8d7ca02e5912f8cb89
Gy = 0x8559ff52fe197ebccbbac18b08d2357db9d01a7952c28a9c8a918fa9bd58e3dc
``` 

Has an order on the curve with

```
B_prime = 87141810357877800334735859453509209467794565735898098218969231306558751088856
E = EllipticCurve(GF(p_NIST), [-3, B_prime])
G = E(Gx, Gy)
# G.order() = 5263276782288920398304429406791253342296478557414290806433459571651589156874
# order_factors = [2, 11, 103, 9007, 23251, 2829341, 12490680737, 92928915967, 390971098981, 1056753725227, 8173984130089]
```

It took about 15 minutes to find this point, but maybe I got lucky. You can see how the curve was found in `check.sage`. 

- We see the largest factor has ~40 bits. Using Pohlig-Hellman with BSGS, we expect this to need ~2^20 operations to solve the discrete log problem. The `solve.py` script takes less than 2 mins to solve the discrete log problem to obtain the flag.

- For the easy solution, you can use Sage's `discrete_log()`, I wrote my own using `gpmy2` in python as it was much faster.


