const express = require('express')
const cors = require('cors')

const corsOption = {
	origin:['http://127.0.0.1:8000'],
 };

const app = express()
app.use(cors())

const app2 = express()
app2.use(cors())

app.use(express.json());
app2.use(express.json())

const initialDate = Date.now().toString();
const showLogMode = false;

adminUser = "user"
adminPass = "ppXr5yGXe2g83X0"
key = "vOc!&6k(G;uNSqjQBt=M"

// middleware
app.use((req,res,next)=>{
    console.log(req.method,req.url);
    console.log(req.hostname)
    next();
})

// ratelimit throughout server
isRateLimited = false;
creds = "ftp_dev:vOc!&6k(G;uNSqjQBt=M"

app2.post('/verify',(req,res)=>{
    p = req.body.password||''
    u = req.body.username||''
    if (u == adminUser && p == adminPass){
        res.send({msg:creds})
    }
    else{
        var errorCode = 0;
        for(var i = 0; i< Math.min(p.length,adminPass.length);i+=1){
            if (p[i] == adminPass[i]){
                errorCode+=1
            }else{break}
        }
        res.send({msg:errorCode})
    }
})

logs = []

function safeT(t){
    if (isNaN(t)){
        for(var i = t.length-1; i>=0; i-=1){
            t = t.split(key[i%key.length]).reverse().join(key[i%key.length]);
        }
    }
    return t
}

app.get('/issueRateLimit',(req,res)=>{
    isRateLimited = true
    var t = req.query.t || Date.now().toString()
    var timeDiff = 0;
    try{
        timeDiff = eval(safeT(t)+'-'+initialDate)/1000
    }
    catch(e){
        console.log("Flagging user")
    }
    rateLimit = `Ratelimit ${req.query.u}, ${timeDiff} seconds`;
    logs.push(rateLimit)
    if (showLogMode){
        console.log(logs)
    }
    setTimeout(()=>{
        isRateLimited = false;
    },5000);

    res.send({msg:`Incorrect Credentials. Error Code: ${req.query.error || "null"}`})
})


app.post('/login',(req,res)=>{
    const bodyData = req.body
    const baseURL = 'http://'+req.hostname
    if(!isRateLimited){
	    //        const endpoint = baseURL+':4000/verify'
	const endpoint = 'http://localhost:4000/verify'
        console.log("ENDPOINT",endpoint)
        fetch(endpoint,{
            method:'POST',
            headers: { 'Content-Type': 'application/json'},
            body:JSON.stringify(bodyData)
        })
        .then((res)=>res.json())
        .then((data)=>{
            if(data.msg == creds){
                res.send(data);
            }
            else{
                if (bodyData.t){
                    res.redirect(baseURL+`:3000/issueRateLimit?u=${bodyData.username}&t=${bodyData.t}&p=${bodyData.password}&error=${data.msg}`);
                }
                else{
                    res.redirect(baseURL+`:3000/issueRateLimit?u=${bodyData.username}&p=${bodyData.password}&error=${data.msg}`);
                }
            }
        })
    }
    else{
        res.send({msg:"You tried too soon"})
    }
})

app.listen(3000, () => {
  console.log(`App1 listening on port 3000`);
});

app2.listen(4000, () => {
  console.log(`App2 listening on port 4000`);
});
