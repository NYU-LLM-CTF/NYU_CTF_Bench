# ES1337

Points: 500

Flag: `flag{Im_trying_to_free_your_mind_But_I_can_only_show_you_the_door_Next_up_for_you_real_pwn2own}`

### Description

```
When ever a new ECMAScript version is released browsers rush to implement the features first.

Looks like *someone* has implemented the new ES1337 replaceIf function for Chrome, but did they make any mistakes along the way?

To help you along this journey we have built both Chrome and V8 for you. See the README.txt for more detailed information!
```

### Files

* `ES1337_NO_CHROME.tar.gz`: (4.3K) README, spec, patch, POW solver (`dist/ES1337_NO_CHROME.tar.gz`)
* `ES1337.tar.gz`: (87M) Includes release chrome build, README, spec, patch, POW solver https://drive.google.com/file/d/1V9liO6e4QGzPTwpBsEVCNtC5hayPnrx8/view?usp=sharing
* `v8_7.0.276.32_csaw.release.tar.gz`: (11M) Release build of V8 with the patch (`dist/v8_7.0.276.32_csaw.release.tar.gz`) 
* `v8_7.0.276.32_csaw.debug.tar.gz`: (711M) Full debug build of V8 with the patch https://drive.google.com/file/d/1W46Hn0HyWtIMosDNkqt5ixEJUyClacUu/view?usp=sharing

### Walkthough

The patch introduces a new array prototype function that allows an element at an array index to be conditionally replaced. However the implementation grabs the array length the wrong way, allowing a user to create a Proxy over the array and return an arbitrary length. (Something about trying JSProxy could be given as a hint if people are stuck)

Normally this would cause the slow path to go, but the code also "optimizes" away the proxy so you can access OOB on an array:

```
let target_float_array = new Array(10);
target_float_array.fill(1.1);

let float_proxy = new Proxy(target_float_array, {
    get: function(obj, prop) {
        if (prop == 'length')
            return 0xffffffff;
        return obj[prop];
    }
});

float_proxy.replaceIf(0x20, (d)=>console.log(d), 0);
```

Reading and replacing OOB with a float array allows players to leak memory as 64bit floats and write arbitrary data as 64bit floats.

A TypedArray can be allocated directly after the array, and the backing store pointer controlled with the OOB write, giving arbitrary read and write.

A normal JSValue array can placed after the float array as well, allowing players to leak the address of arbitrary objects.

Since the patch also enables the RWX JIT, players can leak the address of a JITed function object, and then leak an address to the JIT page.
Using the write they can write shellcode over the JIT function and run it by calling the function object.
