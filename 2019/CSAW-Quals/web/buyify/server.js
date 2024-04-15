/* === Imports === */
const vm = require('vm');
const fs = require('fs');
const util = require('util');
const crypto = require('crypto');
const express = require('express');
const session = require('express-session');
const finalhandler = require('finalhandler');
const exphbs  = require('express-handlebars');
const store_router = new vm.Script(fs.readFileSync('store.js'));

let store_count = 0;
let money_count = 0;
let user_count = 0;
let flag_count = 0;

/* === Store database === */
let stores = {};
let items = {};

// Isolate each store into a seperate context
function create_store(name, id) {
  if (id === undefined)
    id = crypto.randomBytes(8).toString('hex');

  let global = {
    console: console,
    g_get_item: get_item,
    g_create_item: create_item.bind(null, id)
  };

  context = store_router.runInNewContext(global, {displayErrors:true});
  context.init(require, id, name);

  stores[id] = context;
  store_count++;
  return id;
}

// Create an item, assign it an id, and store its callback
function create_item(id, name, callback) {
  let item_id = `${id}.${name}`;
  items[item_id] = callback;
  return item_id;
}

// Get an item callback
function get_item(item) {
  money_count += item.price;
  return items[item.id];
}

// Create the Flag store and the Flag item
stores[create_store('Flag','flag')].create_item('flag', 100000000, (id, req, res)=>{
  if (flag_count == 0) {
    flag_count++;
    res.send(`Congrats! Your flag is ${
        fs.readFileSync('flag.txt').toString().replace(/^\s+|\s+$/g, '')}!`);
    setTimeout(function() {
      process.exit(0);
    },500);
  }
});

/* === Express === */
const app = express()

// Add handlebars view renderer
app.engine('handlebars', exphbs());
app.set('view engine', 'handlebars');
app.enable('view cache');

app.use(express.urlencoded({ extended: true }))

// Create signed sessions with a long random string
app.use(session({
    secret: crypto.randomBytes(64).toString('hex'),
    resave: false,
    saveUninitialized: true,
}))

app.get('/store', (req, res) => {
  res.render('new');
});

app.get('/', (req, res) => {
  res.render('index',{
    store_count: store_count,
    money_count: money_count,
    user_count: user_count,
    flag_count: flag_count,
  });
});

app.post('/store', (req, res) => {
  let name = req.body.name.toString();
  let id = create_store(name);
  req.session.admin = id;
  return res.redirect(`/store/${id}/`);
});

app.use('/store/:store_id/', (req, res) => {
  if (req.session.money === undefined) {
    req.session.money = 100;
    user_count++;
  }

  let id = req.params['store_id'];
  if (id === undefined)
    return res.status(404).end()

  if (!(id in stores) || !stores.propertyIsEnumerable(id))
    return res.redirect(`/store`);

  // Use the router for the store
  stores[id].handle(req, res, finalhandler(req, res));
});


app.listen(3000)
