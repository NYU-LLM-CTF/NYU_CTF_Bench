export function getInt32Bytes( input ){
    var bytes = []
    let x = parseInt(input)
    var i = 4;
    do {
        bytes[--i] = x & (255);
        x = x>>8;
    } while ( i )
    return bytes;
}

export function word2Int(word) {
    let res = 0
    let i = 0;
    let j = 3;
    do {
        console.log(word.charCodeAt(i))
        res += word.charCodeAt(i) * Math.pow(2,8*j)
        i ++
        
    }while(j--)
    return res
}
export function getCharCodes(input){
    const word = getInt32Bytes(input)
    let res = ""
    for(let i = 0; i < word.length; i++){
        res += String.fromCharCode(word[i])
    }
    return res
}