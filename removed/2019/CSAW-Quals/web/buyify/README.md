# Buyify

Points: 450-500? (kinda needs a minor 0day)

Flag: `flag{always_perform_variant_analysis_when_fixing_bugs}`

Description

```
We know other other e-commerce sites have had horrible bugs recently, but our IT department says with the new versions of our dependencies, everything will be fine..

[buyify.zip]
```

### Walkthough

This challenge lets users create a shop and perform template injection. To solve this, we have to exploit an issue in handlebars.js.
Handlebars allows templates to call helper functions and also access attributes. If we look for previous vulnerabilities in handlebars,
there someone used these features to achieve RCE in shopify. The basic idea of how the attack worked is to access the `constructor` attribute
in the `__proto__` and use it to access `Object.defineProperty` to assign properties to `Object.prototype`, performing prototype injection.

The fix for this issue was to blacklist constructor from property lookup. However we can still access `__proto__` and `__defineGetter__`.
We can abuse this by doing
```
{{#with this.__proto__}}{{#this.__defineGetter__ "key" this.toString}}{{/with}}
```
This will set Object.prototype['key'] to '[object Object]' (or could be some other known string)

Now we can sign a request for `flag.flag` for price 0 using key '[object Object]'

