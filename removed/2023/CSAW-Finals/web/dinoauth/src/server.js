const koa = require('koa');
const bodyParser = require('koa-bodyparser');
const session = require('koa-session');
const oauthRouter = require('./routers/oauth-router');
const apiRouter = require('./routers/api-router');

const app = new koa();

app.keys = ['NNSWK4C7PFXXK4S7NNXWCX3TMVZXGX3TNFTV643FMN2XEZI='];

app.use(session(app));
app.use(async (ctx, next) => {
    try {
        ctx.request.session = ctx.session;
        await next();
    } catch (e) {
		console.log(`[server] error processing request: ${e}`)
        
        ctx = null;
    }
});

app.use(oauthRouter(app, { 'prefix': '/oauth' }).routes());
app.use(apiRouter(app, { prefix: '/api' }).routes());

app.listen(3002, function () {
    console.log('oauth server listening on port 3002');
});
