pragma solidity ^0.4.16;
contract ethersplay {

    struct Play {
        uint weight;
        bool played;
        uint8 score;
        address addr;
    }
    struct players {
        uint playCount;
    }

    address mc;
    mapping(address => Play) transaction;
    players[] p;

    function ethersplay(uint8 _numPlayers) {
        mc = msg.sender;
        transaction[mc].weight = 1;
        p.length = _numPlayers;
    }

    function giveTurnToPlay(address current) {
        if (msg.sender != mc || transaction[current].played) return;
        transaction[current].weight = 1;
    }

    function go(uint8 card) {
        Play current = transaction[msg.sender];
        if (current.played || card >= p.length) return;
        current.played = true;
        current.score = card;
        p[card].playCount += current.weight;
    }

    function winningCard() constant returns (uint8 wCard) {
        uint256 winningScore = 0;
        for (uint8 card = 0; card < p.length; card++)
            if (p[card].playCount > winningScore) {
                winningScore = p[card].playCount;
                wCard = card;
            }
    }

function stringToBytes(string memory source) returns (bytes result) {
    assembly {
        result := mload(add(source, 32))
    }
}

  function bytes20ToString(bytes20 x) constant returns (string) {
    bytes memory bytesString = new bytes(20);
    uint charCount = 0;
    for (uint j = 0; j < 20; j++) {
        byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
        if (char != 0) {
            bytesString[charCount] = char;
            charCount++;
        }
    }
    bytes memory bytesStringTrimmed = new bytes(charCount);
    for (j = 0; j < charCount; j++) {
        bytesStringTrimmed[j] = bytesString[j];
    }
    return string(bytesStringTrimmed);
} 

    function supercustomhash(bytes message) public constant returns(bytes20 ret){
        assembly {
            switch div(calldataload(0), exp(2, 224))
            case 0x1605782b { }
            default { revert(0, 0) }
            let data := add(calldataload(4), 4)

            // Get the data length, and point data at the first byte
            let len := calldataload(data)
            data := add(data, 32)

            // Find the length after padding
            let totallen := add(and(add(len, 1), 0xFFFFFFFFFFFFFFC0), 64)
            switch lt(sub(totallen, len), 9)
            case 1 { totallen := add(totallen, 64) }

            let h := 0x6745230100EFCDAB890098BADCFE001032547600C3D2E1F0

            for { let i := 0 } lt(i, totallen) { i := add(i, 64) } {
                // Load 64 bytes of data
                calldatacopy(0, add(data, i), 64)

                // If we loaded the last byte, store the terminator byte
                switch lt(sub(len, i), 64)
                case 1 { mstore8(sub(len, i), 0x80) }

                // If this is the last block, store the length
                switch eq(i, sub(totallen, 64))
                case 1 { mstore(32, or(mload(32), mul(len, 8))) }

                // Expand the 16 32-bit words into 80
                for { let j := 64 } lt(j, 128) { j := add(j, 12) } {
                    let temp := xor(xor(mload(sub(j, 12)), mload(sub(j, 32))), xor(mload(sub(j, 56)), mload(sub(j, 64))))
                    temp := or(and(mul(temp, 2), 0xFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFE), and(div(temp, exp(2, 31)), 0x0000000100000001000000010000000100000001000000010000000100000001))
                    mstore(j, temp)
                }
                for { let j := 128 } lt(j, 320) { j := add(j, 24) } {
                    let temp := xor(xor(mload(sub(j, 24)), mload(sub(j, 64))), xor(mload(sub(j, 112)), mload(sub(j, 128))))
                    temp := or(and(mul(temp, 4), 0xFFFFFFFCFFFFFFFCFFFFFFFCFFFFFFFCFFFFFFFCFFFFFFFCFFFFFFFCFFFFFFFC), and(div(temp, exp(2, 30)), 0x0000000300000003000000030000000300000003000000030000000300000003))
                    mstore(j, temp)
                }

                let x := h
                let f := 0
                let k := 0
                for { let j := 0 } lt(j, 80) { j := add(j, 1) } {
                    switch div(j, 20)
                    case 0 {
                        // f = d xor (b and (c xor d))
                        f := xor(div(x, exp(2, 80)), div(x, exp(2, 40)))
                        f := and(div(x, exp(2, 120)), f)
                        f := xor(div(x, exp(2, 40)), f)
                        k := 0x5A827999
                    }
                    case 1{
                        // f = b xor c xor d
                        f := xor(div(x, exp(2, 120)), div(x, exp(2, 80)))
                        f := xor(div(x, exp(2, 40)), f)
                        k := 0x6ED9EBA1
                    }
                    case 2 {
                        // f = (b and c) or (d and (b or c))
                        f := or(div(x, exp(2, 120)), div(x, exp(2, 80)))
                        f := and(div(x, exp(2, 40)), f)
                        f := or(and(div(x, exp(2, 120)), div(x, exp(2, 80))), f)
                        k := 0x8F1BBCDC
                    }
                    case 3 {
                        // f = b xor c xor d
                        f := xor(div(x, exp(2, 120)), div(x, exp(2, 80)))
                        f := xor(div(x, exp(2, 40)), f)
                        k := 0xCA62C1D6
                    }
                    // temp = (a leftrotate 5) + f + e + k + w[i]
                    let temp := and(div(x, exp(2, 187)), 0x1F)
                    temp := or(and(div(x, exp(2, 155)), 0xFFFFFFE0), temp)
                    temp := add(f, temp)
                    temp := add(and(x, 0xFFFFFFFF), temp)
                    temp := add(k, temp)
                    temp := add(div(mload(mul(j, 4)), exp(2, 224)), temp)
                    x := or(div(x, exp(2, 40)), mul(temp, exp(2, 160)))
                    x := or(and(x, 0xFFFFFFFF00FFFFFFFF000000000000FFFFFFFF00FFFFFFFF), mul(or(and(div(x, exp(2, 50)), 0xC0000000), and(div(x, exp(2, 82)), 0x3FFFFFFF)), exp(2, 80)))
                }

                h := and(add(h, x), 0xFFFFFFFF00FFFFFFFF00FFFFFFFF00FFFFFFFF00FFFFFFFF)
            }
            h := or(or(or(or(and(div(h, exp(2, 32)), 0xFFFFFFFF00000000000000000000000000000000), and(div(h, exp(2, 24)), 0xFFFFFFFF000000000000000000000000)), and(div(h, exp(2, 16)), 0xFFFFFFFF0000000000000000)), and(div(h, exp(2, 8)), 0xFFFFFFFF00000000)), and(h, 0xFFFFFFFF))
            //log1(0, 0, h)
            mstore(0, h)
            return(12, 20)
        }
    }

function strConcat(bytes _a, string _b, bytes _c) internal returns (string){
    bytes memory _ba = _a;
    bytes memory _bb = bytes(_b);
    bytes memory _bc = _c;
    string memory abcde = new string(_ba.length + _bb.length + _bc.length );
    bytes memory babcde = bytes(abcde);
    uint k = 0;
    for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
    for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
    for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
    return string(babcde);
}


    function addPlayerName(string name) constant returns (string result) {
	result = "Successfully added name to database";
	if( bytes(name).length != 6){
		result = "Incorrect name length";
	}
        bytes memory salt = "_tothemoon}";
        bytes memory salt2 = "flag{";
	// flag{ETHBTC_tothemoon}
	string memory temp = strConcat(salt2, name, salt);
	
	bytes memory a = stringToBytes(temp);
	bytes20 b = supercustomhash(a);
	string memory hash = bytes20ToString(b);
	if (sha3(hash) == sha3('678af730101e444b5ea458b6652f6b2d0ed8b7e6')){
            result = "Welcome cryptofuturist";
        }
        
    }
}
