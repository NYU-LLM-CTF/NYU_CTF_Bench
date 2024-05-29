const Koa = require('koa');
const Router = require('koa-router');
const bodyParser = require('koa-bodyparser');
const logger = require('koa-logger');
const session = require('koa-session');
const qs = require('querystring');
const jwt = require('jsonwebtoken');

const app = new Koa();
const router = new Router();

app.keys = [process.env.SECRET_KEY || 'keyboard cat'];

router.get('/', async ctx => {

  ctx.body = `
  <h1>Welcome to our SINGLE SIGN ON PAGE WITH FULL OAUTH2.0!</h1>
  <a href="/protected">.</a>
  <!--
  Wish we had an automatic GET route for /authorize... well they'll just have to POST from their own clients I guess
  POST /oauth2/token
  POST /oauth2/authorize form-data TODO: make a form for this route
  --!>
  `;
});

router.get('/login', async ctx => {
  ctx.body = `
  <form method="POST">
    Username: <input type="text" name="username" />
    Password: <input type="password" name="password" />
    <input type="submit" />
  </form>
  `
});

router.post('/login', async ctx => {

  const { username, password } = ctx.request.body;

  if (!username || !password) return ctx.throw(400, "Missing username or password!");


  ctx.session.type = "user";

  ctx.body = `
  <p>Successfully logged in!</p>
  `;
});

async function checkLogin(ctx, next) {
  const { type } = ctx.session;
  if (type === null) return ctx.redirect('/login');
  else await next();
}

async function authorizationCode(data) {
  return new Promise((resolve, reject) => {
    jwt.sign(
      { ...data }, 
      process.env.JWT_SECRET || 'keyboard_cat', 
      { expiresIn: '10m' }, 
      (err, token) => {
        if (err) return reject(err);
        return resolve(token);
    });
  });
}

async function verifyToken(token) {
  return new Promise((resolve, reject) => {
    jwt.verify(
      token,
      process.env.JWT_SECRET || 'keyboard_cat',
      (err, data) => {
        if (err) return reject(err);
        return resolve(data);
      }
    );
  });
}

router.post('/oauth2/authorize', checkLogin, async ctx => {
  const { client_id, redirect_uri, response_type, state } = ctx.request.body;

  if (response_type == 'code') {
    
    const code = await authorizationCode({
      client_id,
      redirect_uri,
      type: ctx.session.type,
    });

    const data = {
      code,
      state,
    };
    return ctx.redirect(redirect_uri + '?' + qs.stringify(data));
  }

  return ctx.throw(400, "response_type not code");
});

router.post('/oauth2/token', async ctx => {
  const { client_id, grant_type, code, redirect_uri } = ctx.request.body;

  if (grant_type == 'authorization_code') {
    if (!code || !redirect_uri) return ctx.throw(400, "Missing parameters");

    const { client_id: _client_id, redirect_uri: _redirect_uri, type } = await verifyToken(code);
    if (client_id != _client_id) return ctx.throw(400);
    if (redirect_uri != _redirect_uri) return ctx.throw(400);

    const data = {
      type : 'user',
      secret: process.env.JWT_SECRET
    };

    const token = await authorizationCode(data);
    ctx.body = {
      token_type: 'Bearer',
      token,
    };

    return;
  }

  return ctx.throw(400, 'incorrect grant_type');
});



async function checkAuthentication(ctx, next) {
  console.log(ctx.request);
  const authorization_header = ctx.request.header.authorization;
  if (!authorization_header) return ctx.throw(400, 'Missing header: Authorization');
  const [bearer, token] = authorization_header.split(' ');

  console.log(bearer, token);

  if (bearer != 'Bearer') return ctx.throw(400, "Incorrect header: Authorization");

  const auth = await verifyToken(token)
    .catch(err => {
      return ctx.throw(401, "Your token could not be verified. Is it expired or not issued by this server?");
    });

  if (auth.type !== 'admin') return ctx.throw(401, "You must be admin to access this resource");
  await next();
}

router.get('/protected', checkAuthentication, async ctx => {

  ctx.body = process.env.FLAG;
});

app.use(logger());
app.use(bodyParser());
app.use(session({
  key: 'CSAW-CTF-2018-QUALS-SSO',
}, app));
app.use(router.routes(), router.allowedMethods());

app.listen(8000);