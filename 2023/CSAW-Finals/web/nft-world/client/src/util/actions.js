import {Arg, Message, Response} from './protocol.js'
import { getCharCodes } from './bitmath.js'
import {SERVER_URL} from './constants.js'
import { checkPropTypes } from 'prop-types'

const commandCodes = {
    getAccount: "\x01",
    buyNft:"\x02",
    getNftLoc: "\x03",
    renameNft: "\x04",
    debug: "\xfe"
}

export async function getNftLoc(nftId) {
    const uid = getCharCodes(localStorage.getItem("userId"))
    const cmd = commandCodes.getNftLoc
    const numArgs = "\x01"
    const argLen = "\x04"
    const arg = getCharCodes(nftId)
    const argObj = new Arg(argLen, arg)
    const message = new Message(uid, cmd, numArgs, [argObj])
    const data = btoa(message.Serialize())

    const requestOptions = {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ data: data})
    };
    return new Promise((resolve, reject) => {
        fetch(SERVER_URL + '/cmd', requestOptions)
        .then((response) => {
            const text = response.text()
            .then((data) => {
                const resp = new Response(atob(data));
                resolve(resp);
            })
            .catch((error) => {reject(error)}) 
        })
        .catch((error) => {reject(error)});
    });

}
export async function getAccount(userName){
    const uid = getCharCodes(localStorage.getItem("userId"))
    const cmd = commandCodes.getAccount
    const numArgs = "\x01"
    const argLen = String.fromCharCode(userName.length)
    const arg = userName
    const argObj = new Arg(argLen, arg)
    const message = new Message(uid, cmd, numArgs, [argObj])
    const data = btoa(message.Serialize())

    const requestOptions = {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ data: data})
    };
    return new Promise((resolve, reject) => {
        fetch(SERVER_URL + '/cmd', requestOptions)
        .then((response) => {
            response.text()
            .then((data) => {
                const resp = new Response(atob(data));
                resolve(resp);
            })
            .catch((error) => {reject(error)}) 
        })
        .catch((error) => {reject(error)});
    });
}
export async function buyNft(id){

    const uid = getCharCodes(localStorage.getItem("userId"))
    const cmd = commandCodes.buyNft
    const numArgs = "\x01"
    const argLen = "\x04"
    const arg = getCharCodes(id)
    const argObj = new Arg(argLen, arg)
    const message = new Message(uid, cmd, numArgs, [argObj])
    const data = btoa(message.Serialize())

    const requestOptions = {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ data: data})
    };
    return new Promise((resolve, reject) => {
        fetch(SERVER_URL + '/cmd', requestOptions)
        .then((response) => {
            const text = response.text()
            .then((data) => {
                const resp = new Response(atob(data));
                resolve(resp);
            })
            .catch((error) => {reject(error)}) 
        })
        .catch((error) => {reject(error)});
    });
}
export async function renameNft(id, newName){

    const uid = getCharCodes(localStorage.getItem("userId"))
    const cmd = commandCodes.renameNft
    const numArgs = "\x02"

    const argLen1 = "\x04"
    const arg1 = getCharCodes(id)
    const arg1Obj = new Arg(argLen1, arg1)

    const argLen2 = String.fromCharCode(newName.length)
    const arg2 = newName
    const arg2Obj= new Arg(argLen2, arg2)

    const message = new Message(uid, cmd, numArgs, [arg1Obj, arg2Obj])
    const data = btoa(message.Serialize())

    const requestOptions = {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ data: data})
    };
    return new Promise((resolve, reject) => {
        fetch(SERVER_URL + '/cmd', requestOptions)
        .then((response) => {
            const text = response.text()
            .then((data) => {
                const resp = new Response(atob(data));
                resolve(resp);
            })
            .catch((error) => {reject(error)}) 
        })
        .catch((error) => {reject(error)});
    });

}
export async function getCaptcha() {
    return new Promise((resolve) => {
        grecaptcha.enterprise.ready(async () => {
            const token =  await grecaptcha.enterprise.execute(
                '6LeNlionAAAAAIqcG1t8RiUD_v4XD_92ryzu5tib', {action: 'CREATE'});
            resolve(token);
        })
    })
}

export async function createAccount(username, token) {
        const requestOptions = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ username: username, captcha: token})
        };
        return new Promise((resolve, reject) => {
            fetch(SERVER_URL + '/create_account', requestOptions).then((data) => {
                data.text()
                .then((blob) => {
                    const resp = new Response(atob(blob));
                    resolve(resp);
                })
                .catch((error) => {
                    reject(error);
                })
            }).catch((error) => {
                reject(error);
            })
        });
}
export async function getGamestate(username, token) {
        const requestOptions = {
            method: 'GET',
        };
        return new Promise((resolve, reject) => {
            fetch(SERVER_URL + '/static/gamestate.json', requestOptions).then((data) => {
                data.json()
                .then((blob) => {
                    resolve(blob);
                })
                .catch((error) => {
                    reject(error);
                })
            }).catch((error) => {
                reject(error);
            })
        });
}