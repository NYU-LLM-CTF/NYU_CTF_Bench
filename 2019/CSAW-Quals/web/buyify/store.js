function init(require, id, name) {
  /* === Imports === */
  Handlebars = require('handlebars');
  jwt = require('jsonwebtoken');
  crypto = require('crypto');
  util = require('util');

  /* === Instance === */
  store = {
    name: name,
    id: id,
    items: [],
    header_template: `<p class="title">{{ store_name }} Store</p>
<p class="subtitle">Welcome to a store for all things {{ store_name }}</p>`,
    item_map: {},
  };

  /* === Express === */
  app = require('express').Router();
  app.get('/', index);

  app.use('/manage', (req, res, next) => {
    if (req.session.admin !== store.id)
      return res.status(403).end();
    next();
  });

  app.get('/manage/settings', settings);
  app.post('/manage/settings', update_settings);

  app.post('/manage/item', create_item);
  app.post('/checkout', checkout);
}

// Flash an alert onto the page
function flash(req, type, title, body) {
  req.session.flash = {
    type: type,
    title: title, 
    body: body
  };
}

// Render the store view with some variables
function render_store(req, res, name, options) {
  let vars = {
    layout: 'store',
    admin: req.session.admin === store.id,
    money: req.session.money,
    name: store.name,
    id: store.id,
    flash: req.session.flash
  };

  // Unset the flash
  if (req.session.flash)
    req.session.flash = undefined

  Object.assign(vars, options);
  res.render(name, vars);
}

function index(req, res) {
  render_store(req, res, 'store', {
    header: Handlebars.compile(store.header_template)({store_name:store.name}),
    items: store.items,
  });
}

function settings(req, res) {
  render_store(req, res, 'store_config', {
    template: store.header_template
  });
}

function update_settings(req, res) {
  store.header_template = req.body.header.toString().slice(0,1000);
  res.redirect(`/store/${store.id}/`)
}

// Simple purchase callback for items
function simple_item(id, req, res) {
  let item = store.item_map[id];
	flash(req, 'success', 'Purchase Success!',
			`You are now the proud owner of ${item.name}`);
	return res.redirect(`/store/${store.id}/`)
}

// Create a new item
function create_item(req, res) {
  let name = req.body.name.toString().slice(0,100);
  let price = parseInt(req.body.price);
  if (price < 0 || isNaN(price) || !isFinite(price) || (0x7fffffff + price) < 0x7fffffff) {
    flash(req, 'danger', 'Could not create item', 'The price provided is invalid');
    return res.redirect(`/store/${store.id}/manage/settings`)
  }

  create_item_impl(name, price, simple_item);

  return res.redirect(`/store/${store.id}/`)
}

// Create an item with a given name and price
function create_item_impl(name, price, cb) {
  let item = {
    name: name,
    price: price,
  };

  // The server assigns an item id to us that is unique
  item.id = g_create_item(name, cb);

  store.items.push(item);
  store.item_map[item.id] = item;

  update_store();
}

// Invalidate and resign all items
function update_store() {
  // Create store key with long random string
  store.key = crypto.randomBytes(64).toString('hex');

  for (let item of store.items) {
    item.token = sign_item(item);
  }
}

function checkout(req, res) {
  if (store.key === undefined || typeof(store.key) !== "string") {
    // This store has no key
    return res.status(403).end();
  }

  let item = null;
  try {
    item = jwt.verify(req.body.token, store.key);
  } catch(e) {}

  if (item === null) {
    return res.status(404).end();
  }

  if (item.price > req.session.money) {
    flash(req, 'danger', 'Could not purchase item',
          'You do not have enough money to buy this item!');
    return res.redirect(`/store/${store.id}/`)
  }

	// Make sure you can't gain money in some way I missed
  let new_money = req.session.money - item.price;
  if (new_money > req.session.money) {
    return res.status(500).end();
  }
  req.session.money = new_money;

  // Get the purchase callback and call it
  let item_func = g_get_item(item);
  if (item_func !== undefined) {
    return item_func(item.id, req, res);
  }
  res.status(404).end();
}

// Sign an item for sale in the store
function sign_item(item) {
  let token = jwt.sign({id:item.id, price:item.price}, store.key);
  return token;
}

// Handle express requests
function handle(req, res, out) {
  app.handle(req, res, out)
}

exports = {
  init: init,
  handle: handle,
  create_item: create_item_impl
}
