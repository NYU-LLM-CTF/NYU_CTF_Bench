const express = require('express')
const {mdToPdf} = require('md-to-pdf')
const app = express()
const port = 3000


app.use(express.urlencoded({
    extended: true
}))


app.get('/', (req, res) => {
    res.sendFile(__dirname + '/static/index.html')
})

app.post('/submit', async (req, res) => {
    console.log(req.socket.remoteAddress);
    console.log(req.ip);
    console.log(req.body.md_data);
    const md_string = req.body.md_data
    if (md_string.search("169.254.169.254") !== -1 || md_string.search("meta-data") !== -1 || md_string.search("security-credentials") !== -1 || md_string.search("Amazon") !== -1)   {

        res.send("AWS is outside of the scope of this challenge.")
        return
    }

    const pdf = await mdToPdf({content: md_string, langugage: 'javascript'}).catch(console.error);
    if (pdf) {

        console.log(pdf.content)
        res.header('Content-type', 'application/pdf')
        res.send(pdf.content)
        return
    }
    else {
        res.send("Bad md code. Aborting.")
        return
    } 
})



var server = app.listen(port, () => {
    console.log(`Node app listening on port ${port}`)
})
server.setTimeout(5000);
