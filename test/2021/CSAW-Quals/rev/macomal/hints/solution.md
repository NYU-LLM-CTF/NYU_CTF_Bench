Here is the solution to this CTF:

- The `.app` bundle's main Mach-O is a SwiftUI app that crahses with a single unique string, `kinda_close_i_guess___`, which is the XOR key used to decrypt the encrypted blob of data hidden inside `runtime.dylib`, which is referenced in an obscure directory `.this/.doesnt/.look/.right` at the root of the app bundle
- The routine with the flag is in `_main.TZj6iqF3jP`
- Each condition is an always-false opaque predicate, so you can either manually patch each branch after the random call to the never branch
- Two hex strings are passed to the call to `_main.New`. The second one is garbage, so the first one should contain a hex byte
- Once you gather them all, decode the flag by XORing with the Swift string
