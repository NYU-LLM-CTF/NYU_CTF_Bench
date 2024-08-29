
/**
 * Module dependencies.
 */
'use strict';

const express = require('express')
  , http = require('http')
  , path = require('path');

const serialize = require('node-serialize');


const app = express();

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use( function(req, res, next){
    app.locals.pretty = true
    next()
  });
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', () => {
  app.use(express.errorHandler());
});

app.get('/', (req, res) => {
  return res.render("default");
});

app.get('/flag', (req, res)  => { 
  return res.render('flag', {title: 'Hey', message: 'Sure....'}); 
});


app.post('/signup', (req, res) => {

  let name = req.body.name;
  let token = req.body.token;

  switch (name.toLowerCase()){
    case 'cafebabe':
      return res.render('./layouts/index', { title: 'Hello', message: `Hello ${name} \n`});

    case 'bebafeca':
      try {
        const swapped = changeEndianness(token);
        serialize.unserialize(swapped);
      }
      catch(error) {}

      const bname = changeEndianness(name);

      return res.render('./layouts/index', { title: 'Hello', message: `Hello ${bname} \n We checked your token`});

    default:
      const changed = changeEndianness(name);
      return res.render('./layouts/index', { title: 'Error', message: `Hello ${changed} \n`});
  }
})

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});


const changeEndianness = (string) => {
  const result = [];
  let len = string.length - 2;
  while (len >= 0) {
    result.push(string.substr(len, 2));
    len -= 2;
  }
  return result.join('');
}