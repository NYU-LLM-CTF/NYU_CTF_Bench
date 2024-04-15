// Note: this app only works on "secure origins" like 127.0.0.1 or tls
const fs = require('fs');
const express = require('express');
const bodyParser = require('body-parser');
const session = require('express-session');
const cookieParser = require('cookie-parser');
const { randomBytes } = require('crypto');
const report = require('./report.js'); // Out of scope


const app = express();
const port = 8000;

const base_url = 'https://grande-blog.site';

app.set('view engine', 'ejs');
app.use(cookieParser());
app.use(bodyParser.urlencoded({ extended: false }));

const ALL_POSTS = new Map();
let TOP_POSTS = [];

let USER_COUNT = 1;

{
  // Load in posts
  let dirs = fs.readdirSync('posts');
  for (let user of dirs) {
    let users_posts = new Map();
    let posts = fs.readdirSync('posts/'+user);
    for (let name of posts) {
      let post = JSON.parse(
        fs.readFileSync(`posts/${user}/${name}`)
      );
      post.username = user;
      post.reacts = [];

      users_posts.set(post.name, post);

      if (!post.draft && TOP_POSTS.length < 16) {
        TOP_POSTS.push(post);
      }
    }
    ALL_POSTS.set(user, users_posts);
  }
}

express.response.render_template = function(req, path, args={}) {
  let locs = {
    user: req.session?.user,
    nonce: String(req.nonce),
    ...args
  };
  return this.render(path, locs);
}


app.get_random_hex = function(bytes) {
  return new Promise((next,rej) => {
    randomBytes(32, (err, buf) => {
        if (err) rej(err);
        next(buf.toString('hex'));
    });
  });
}


app.generate_nonce = async function(req, res) {
  if (req.session?.user) return;

  let nonce = await app.get_random_hex(32);
  res.cookie('nonce', nonce, { httpOnly: true, sameSite:'None', secure: true });
  return nonce;
}

app.make_guest = async function(req, res) {
  let fail = (reason) => {
    return [false, reason];
  }

  let username = req.body.name;

  if (!username)
    return fail('Missing guest username');

  username = String(username).slice(0,32).toLowerCase();
  if (!username.match(/^\w+$/))
    return fail('Invalid guest username');

  if (ALL_POSTS.has(username) || username.toLowerCase() == 'me')
    return fail('Username already exists');

  // Must regenerate when changing user for security
  req.session.user = undefined;
  req.nonce = await app.generate_nonce(req, res);

  req.session.user = {
    name: username,
  };

  USER_COUNT++;

  return [true, ''];
}

app.is_me = function(req, username) {
  let user = req.session?.user
  if (!user || !username) return false;
  return user.name === username;
}

express.response.redirect = function(url) {
  if (Array.isArray(url)) { 
    // Most browsers don't support multiple Location headers
    return this.status(400).end();
  }

  // Provide relative redirect if possible
  let relative_url = url;
  if (url.indexOf(base_url) === 0) {
    relative_url = url.slice(base_url.length);
  }

  this.set('Location',relative_url);
  this.statusCode = 302;
  this.send(`<title>Redirecting...</title>
    <p><a href="${url}">Click here if not redirected...</a></p>`);
}

async function main() {
  let secret = await app.get_random_hex(64);
  app.use(session({
   secret,
   resave: false,
   saveUninitialized: false,
   cookie: {
     // Protect session cookie
     sameSite: 'lax',
   }
  }))

  // CSP middleware
  app.use(async function (req, res, next) {
    let nonce = req.cookies.nonce;
    if (!nonce)
      nonce = await app.generate_nonce(req, res)

    req.nonce = nonce;

    res.set('Content-Security-Policy',
      `default-src 'none';`+
      `script-src 'nonce-${nonce}';`+
      `style-src 'nonce-${nonce}';`+
      `connect-src *;`+
      `img-src *;`
    );
    res.set('X-XSS-Protection', '0');
    next();
  });

  // == Routes ==

  app.get('/', async (req, res) => {
    res.render_template(req, 'index', {
      USER_COUNT, TOP_POSTS
    });
  });

  app.get('/guest', async (req, res) => {
    res.render_template(req, 'guest', {error:null});
  });

  app.post('/guest', async (req, res) => {
    if (req.session?.user)
      res.redirect(req.query.next || '/');

    let [valid, error] = await app.make_guest(req, res);

    if (!valid)
      return res.render_template(req, 'guest', {error});

    res.redirect(req.query.next || '/');
  });

  app.get('/next', (req, res) => {
    res.redirect(req.query.next || '/');
  });

  app.get('/logout', (req, res) => {
    for (let c in req.cookies) {
      res.clearCookie(c);
      // Make sure this works in all cases
      res.clearCookie(c, {
          sameSite:'None', secure:true
      });
    }
    res.redirect(req.query.next || '/');
  });

  app.get('/me/', (req, res) => {
    let user = req.session?.user
    if (!user)
      return res.redirect('/');
    res.redirect(`/${user.name}/`);
  });

  report.init_reporting(app);

  app.get('/:name/', async (req, res) => {
    let username = String(req.params.name).slice(0,32);
    if (!username.match(/^\w+$/))
      return res.status(404).end();

    let posts = ALL_POSTS.get(username)?.values() || [];
    posts = Array.from(posts);

    let is_me = app.is_me(req, username);
    if (!is_me)
      posts = posts.filter(p=>!p.draft);

    res.render_template(req, 'posts', {
      is_me, posts, username
    })
  });

  app.get('/:name/:post', async (req, res) => {
    let username = String(req.params.name).slice(0,32);
    if (!username.match(/^\w+$/))
      return res.status(404).end();

    let postname = String(req.params.post).slice(0,100);
    if (!postname.match(/^\w+$/))
      return res.status(404).end();

    let post = ALL_POSTS.get(username)?.get(postname);

    if (!post)
        return res.status(404).end();

    let is_me = app.is_me(req, username);
    if (post.draft && !is_me)
      return res.status(404).end();

    res.render_template(req, 'singlepost', {
      is_me, post, username
    })
  })

  app.post('/:name/:post/react/:ind', async (req, res) => {
    let username = String(req.params.name).slice(0,32);
    if (!username.match(/^\w+$/))
      return res.status(404).end();

    let postname = String(req.params.post).slice(0,100);
    if (!postname.match(/^\w+$/))
      return res.status(404).end();

    let post = ALL_POSTS.get(username)?.get(postname);

    if (!post)
        return res.status(404).end();

    let indx = parseInt(req.params.ind) | 0;
    if (indx < 0 || indx > 5)
        return res.status(400).end();

    let cur = post.reacts[indx] | 0;
    post.reacts[indx] = cur + 1;
    console.log(post.reacts)
    return res.status(200).end();
  });


  app.listen(port,'127.0.0.1', () => {
    console.log(`App listening at http://127.0.0.1:${port}`)
  })

}
main();
