const express = require('express')
const fs = require('fs')
const randomWords = require('random-words');
const cookieParser = require('cookie-parser');
const { type } = require('os');
const { exit } = require('process');
const app = express()

const port = 3000
const PAGE_LEN = 1000
const TARGET_CHAIN_LEN = 100
const COOKIE_NAME = "solChain"
/// Solution cookie array
var targetChain = "stuff," + randomWords(TARGET_CHAIN_LEN - 1)
///
targetChain = targetChain.split(",")
console.log("Before removing dups: ")
console.log(targetChain)
targetChain = [...new Set(targetChain)] // Remove dups
console.log("After removing dups: ")
console.log(targetChain)

let FLAG_STRING;
try {
    FLAG_STRING = fs.readFileSync('./flag.txt', 'utf8');
  } catch (err) {
    console.error(err);
  }

  
app.set("view engine", "ejs");
app.use(express.urlencoded({
    extended: true
}))
app.use(cookieParser())

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/static/index.html')
})

app.get('/:word', (req, res) => {

    var currentWord = req.params.word
    if (currentWord == "favicon.ico") {
        return;
    }
    console.log("Searching " + currentWord);

    if(currentWord == targetChain[0]){
        res.cookie(COOKIE_NAME, currentWord, {maxAge: 2147483647, httpOnly: false})
        let rand = randomWords(PAGE_LEN)
        rand = insertRandom(rand, targetChain[1])
        res.render('random', {rand: rand, specialWord: targetChain[1]})
        return;
    }


    var index = targetChain.indexOf(currentWord)
    if (index == undefined) {
        console.log("\tCurrentWord not found");
        res.send("Booooo!")
        return;
    }
    var cookie = req.cookies.solChain
    // This will be undefined if we randomly stumble upon this word
    if (cookie == undefined) {
        console.log("\tCookie undefined");
        res.send("Booooo!")
        return;
    }
    cookie = cookie + " " + currentWord;

    var {validChain, completed, nextWord} = checkChain(cookie, index)
    console.log("\tcheckChain returns => " + validChain + ", " + completed + ", " + nextWord)

    if (!validChain) {
        console.log("\tInvalid chain")
        res.send("Booooo!")
    }
    if (completed) {
        res.send(FLAG_STRING)
        return;
    }

    if (nextWord == undefined) {
        res.send("Should not happen, contact challenge admin.")
        return;
    }

    res.cookie(COOKIE_NAME, cookie, {maxAge: 2147483647, httpOnly: false})
    
    const specialWord = nextWord

    let rand = randomWords(PAGE_LEN)
    rand = insertRandom(rand, specialWord)
    res.render('random', {rand: rand, specialWord: specialWord})
    // res.sendFile(__dirname + '/static/index.html')
})

function insertRandom(rand, specialWord) {
    let randPos = Math.floor(Math.random() * (rand.length - 1))
    rand.splice(randPos, 0, specialWord)
    console.log("\tNext word: " + specialWord);
    return rand
}

function checkChain(cookie, index) {
    console.log("\tCookie: " + cookie)
    let res = {
        validChain : false,
        completed : false,
        nextWord : undefined
    }
    let cookieArray = cookie.split(" ") 
    for (let i = 0; i < index; i++) {
        if(cookieArray[i] != targetChain[i]) {
            return res
        }
    }
    res.validChain = true

    // Reached the end of the chain
    if (index == targetChain.length - 1) {
        res.completed = true
        return res
    }

    res.nextWord = targetChain[index+1] 
    return res
}


app.listen(port, () => {
    console.log(`Node app listening on port ${port}`)
})