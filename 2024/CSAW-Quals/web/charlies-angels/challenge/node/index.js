const express = require('express');
const app = express();
const YAML = require('yaml');
const crypto = require("crypto");
const session = require('express-session');
var FileStore = require('session-file-store')(session);
const needle = require("needle");

const angels = require('./angels');
const BACKUP = process.env.backup || "http://localhost:1338";
app.use(express.json());
app.use(express.static('public'))
app.use(session({
    store: new FileStore({
        fileExtension: ".yaml",
        encoder: YAML.stringify,
        decoder: YAML.parse
    }),
    secret: crypto.randomBytes(30).toString('hex'),
    cookie: { secure: false },
    saveUninitialized: true,
    resave: false
}));

app.get('/', (req, res) => {
    res.sendFile('public/html/index.html', {root: __dirname});
});

app.get('/angel', async (req, res) => {
    if (!req.session.angel) {
        req.session.angel = angels.randomAngel();
    }
    const data = {
        id: req.sessionID,
        angel: req.session.angel
    }
    res.set('Content-Type', 'application/json');
    return res.status(200).send(JSON.stringify(data));
});

app.post('/angel', (req, res) => {
    for (const [k,v] of Object.entries(req.body.angel)) {
        if (k != "talents" && typeof v != 'string') {
            return res.status(500).send("ERROR!");
        }
    }
    req.session.angel = {
        name: req.body.angel.name,
        actress: req.body.angel.actress,
        movie: req.body.angel.movie,
        talents: req.body.angel.talents
    };
    const data = {
        id: req.sessionID,
        angel: req.session.angel
    };
    const boundary = Math.random().toString(36).slice(2) + Math.random().toString(36).slice(2);
    needle.post(BACKUP + '/backup', data, {multipart: true, boundary: boundary},  (error, response) => {
        if (error){
            console.log(error);
            return res.status(500).sendFile('public/html/error.html', {root: __dirname});
        }
    });
    return res.status(200).send(req.sessionID);

});

const authn = (req, res, next) => {
    if (!req.session.angel) return res.status(403).sendFile('public/html/error.html', {root: __dirname});
    next();
}

app.get('/restore', authn, (req, res) => {  
    let restoreURL = BACKUP + `/restore?id=${req.sessionID}`;
    console.log(restoreURL);
    needle.get(restoreURL, (error, response) => {
        try {
            if (error) throw new Error(error);
            if (response.body == "ERROR") throw new Error("HTTP Client error");
            return res.send(response.body);
        } catch (e) {
            if (e.message != "HTTP Client error") {
                console.log(e);
            }
            return res.status(500).sendFile('public/html/error.html', {root: __dirname});
        }
    });
});

app.all('*', (req, res) => {
    return res.status(404).sendFile('public/html/error.html', {root: __dirname});
});

const PORT = 1337;
app.listen(PORT, () => {
    console.log(`[${new Date(Date.now())}]: Listening on port ${PORT}`);
});
