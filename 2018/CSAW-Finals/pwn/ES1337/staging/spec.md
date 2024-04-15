# ECMAScript® 1337 Language Specification Extensions

### 22.1.3.58 Array.prototype.replaceIf(index, callbackfn, replacement)

> Note 1: _callbackfn_ should be a function that accepts one argument. *replaceIf* calls
_callbackfn_ with the array element at index _index_. **"length"** bounds are checked
after _callbackfn_ is called to account for state changes during the callback.


When the **replaceIf** method is called, the following steps are taken:

1. Let _O_ be ? ToObject(**this** value).
2. Let _len_ be ? ToLength(? Get(_O_, **"length"**)).
3. Let _n_ ? ToInteger(_index_).
4. If _len_ < _n_, return **false**.
5. If IsCallable(_callbackfn_) is **false**, return **false**.
6. Let _e_ be ? Get(_O_,_n_).
7. Let _shouldReplace_ be ToBoolean(? Call(_callbackfn_,_e_)).
8. If _shouldReplace_ is *false*, return *false*.
9. Let _len_ be ? ToLength(? Get(_O_, **"length"**)).
10. If _len_ < _n_, return **false**.
11. Perform Set(_O_, _n_, _replacement_).
12. Return **true**.

