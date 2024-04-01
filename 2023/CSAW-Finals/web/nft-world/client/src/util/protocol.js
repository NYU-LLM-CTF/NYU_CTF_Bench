import {signData} from './signer.js'

export class Arg {
    constructor(argLen, arg){
        this.argLen = argLen;
        this.arg = arg;
    }
    Serialize() {
       let result = "";
       result += this.argLen;
       result += this.arg;
       return result
    }
}
export class Message {
    constructor(uid, cmd, numArgs, args){
        this.uid = uid;
        this.cmd = cmd;
        this.numArgs = numArgs;
        this.args = args;
    };
    Serialize() {
       let result = "";
       result += this.uid;
       result += this.cmd;
       result += this.numArgs;
       for( let i = 0; i < this.numArgs.charCodeAt(0); i ++ ){
        result += this.args[i].Serialize();
       }
       return signData(result) 
    }
}

export class Response {
    constructor(bytes) {
        this.respCode = bytes[0].charCodeAt(0)
        this.messageLen = bytes[1].charCodeAt(0)
        this.message = bytes.slice(2,this.messageLen + 2)
    }
}