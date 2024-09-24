var express = require('express');
var app = express();
var bodyParser = require('body-parser'); 
app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json());

var key = "r2wV9hl+9GMBT9IpD6YWJJB6DkMq6HSYVhHD/lRx58w="
var halfkey = "9GMBT9IpD6YWJJB6DkMq6HSYVhHD/lRx58w="
var flag = "{@nya_haha_1nakute_5amishii}"
var port = 10010

app.get('/', (req, res)=>{
   res.send('Hello World');
})

app.post('/', (req, res)=>{
    console.log(req.body)
    var myVar = req.body.data
    if (typeof myVar === 'string' || myVar instanceof String){
        setTimeout(()=>{
            var A = req.body.data.includes(halfkey)
            if (req.body.data == key || A){
                res.send(flag)
            }
            else{
                res.send("")
            }
        }, 100)
    }
})

var server = app.listen(port, ()=>{
   var host = server.address().address
   var port = server.address().port
   
   console.log("Listening at http://%s:%s", host, port)
})