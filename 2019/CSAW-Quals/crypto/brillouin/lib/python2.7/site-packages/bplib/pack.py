from .bp import BpGroup, G1Elem, G2Elem, GTElem

try:
    from petlib.pack import encode, decode, register_coders
    import msgpack
except:
    print("Avoid imports to compile docs")

def g_enc(obj):
    return msgpack.packb( obj.nid )

def g_dec(data):
    nid = msgpack.unpackb(data)
    return BpGroup(nid)

def pt_enc(obj):
    return msgpack.packb( (obj.group.nid, obj.export() ) )

def pt_decoder(xtype):
    def dec(data):
        (nid, bts) = msgpack.unpackb(data)
        G = BpGroup(nid)
        pt = xtype.from_bytes(bts, G) 
        return pt
    return dec

try:
    register_coders(BpGroup, 100, g_enc, g_dec)
    register_coders(G1Elem, 101, pt_enc, pt_decoder(G1Elem))
    register_coders(G2Elem, 102, pt_enc, pt_decoder(G2Elem))
    register_coders(GTElem, 103, pt_enc, pt_decoder(GTElem))
except:
    print("Avoid imports to compile docs")


def test_pack_trivial():
    G = BpGroup()

    # Key Generation
    private = G.order().random()
    pub = private * G.gen2() # The public key

    # Signature
    message = b"Hello World"
    sig = private * G.hashG1(message)
   
    # Verification
    gt = G.pair(sig, G.gen2())
    assert gt == G.pair(G.hashG1(message), pub)

    assert pub == pt_decoder(G2Elem)(pt_enc(pub))
    assert sig == pt_decoder(G1Elem)(pt_enc(sig))
    assert gt == pt_decoder(GTElem)(pt_enc(gt))

def test_pack_full():
    G = BpGroup()

    # Key Generation
    private = G.order().random()
    pub = private * G.gen2() # The public key

    # Signature
    message = b"Hello World"
    sig = private * G.hashG1(message)
   
    # Verification
    gt = G.pair(sig, G.gen2())

    struct = [G, pub, sig, gt]
    data = encode( struct )
    assert struct == decode(data)