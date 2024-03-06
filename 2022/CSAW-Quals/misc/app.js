// Imports
const express = require('express')
const fileUpload = require('express-fileupload')
const multer = require('multer')
const {PythonShell} = require('python-shell')
// const fs = require('fs')
const rimraf = require('rimraf')
const crypto = require('crypto')
const path = require('path')

// Initialize app
const app = express()
const PORT = 3000

// Set view engine for template
app.set('view engine', 'ejs')

// Render the index.ejs
app.get('/', async (req, res, next) => {
    res.render('index', { token: false })
})

// Multer
const savePath = path.join(__dirname, 'uploads')
var fileID = crypto.randomBytes(20).toString("hex")
console.log(fileID)
const fileStorageEngine = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, savePath)
    },
    filename: (req, file, cb) => {
        cb(null, fileID + "-" + file.originalname)
    }
})

const upload = multer({storage: fileStorageEngine})


app.post('/single', upload.single("mFile"), (req, res) => {
    try {
        
        console.log(req.file)

        // console.log(id)
        // Python shell
        let options = {
            scriptPath: './',
            args: [req.file.filename, req.file.originalname, fileID]
        }

        PythonShell.run("script.py", options, (err, result) => {
            
            if (err) {
                console.log(err)
                res.send(err.traceback)
            }
            
            if (result) {
                res.render('index', { token: true, resultVal: "File Upload was Successful!\n" + result})
                const directory = './uploads/';

                // Delete directory once upload is successful and test is run
                // code here...
                rimraf('./uploads/*', function () { console.log('dir has been cleared!') })
            }
        })
          
    } catch (error) {
        res.send("Please check that the accuracy of your model is correct (>90%)\n" + error)
    }
})

app.listen(PORT, () => console.log('Server running on port 3000...'))