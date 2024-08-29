const koa = require('koa');
const Router = require('koa-router');
const bodyParser = require('koa-bodyparser');
const validator = require('koa-async-validator');
const session = require('koa-session');
const path = require('path');
const consolidate = require('consolidate');
const httpUtils = require('./utils/http-utils');
const render = require('koa-ejs');
const serve = require('koa-static');
const oauthRouter = require('./routers/oauth-router');
const apiRouter = require('./routers/api-router');

const host = process.env.HOST;

const app = new koa();
const router = new Router();

render(app, {
    root: path.join(__dirname, '/views'),
    layout: 'index',
    viewExt: 'ejs',
    cache: false,
    debug: false
});

const KOA_SESSION_CONFIG = {
    signed: true,
    secure: false
}

const OAUTH_STATE_EXPIRES_IN = 1000 * 60 * 30;// 30 minutes

const oauthServerInfo = {
    endpoint: {
        'authorize': `http://${host}:3002/oauth/authorize`,
        'register': `http://${host}:3002/oauth/register`,
        'token': `http://${host}:3002/oauth/token`
    },
    api: {
        'error': `http://${host}:3002/api/error`,
        'getUserInfo': `http://${host}:3002/api/user`,
        'home': `http://${host}:3002/api/home`,
        'listDinos': `http://${host}:3002/api/list_dinos`,
        'buyDino': `http://${host}:3002/api/buy_dino`,
        'buyFlagosaurus': `http://${host}:3002/api/buy_flagosaurus`,
    }
};

//these information should match those in the oauth server's client registry
const oauthClientInfo = {
    'id': 'dinomarket_app',
    'clientSecret': 'this_is_the_dinomarket_secret',
    'name': 'Dinomarket App',
    'scope': 'user_info:read,list_dinos,buy_dino,sell_dino',
    'responseType': 'code',
    'grantType': 'authorization_code',
    'redirectUri': `http://${host}:3001/receiveGrant`
};

const templateConfig = {
    'basePath': path.resolve(`${__dirname}/client-views`),
    'ext': 'html',
    'engine': 'lodash'
};

app.keys = ['NNSWK4C7PFXXK4S7NNXWCX3TMVZXGX3TNFTV643FMN2XEZI='];

router.get('/dinomarket_app', async (ctx, next) => {
    await forwardToView(ctx, 'dinomarket_app', {});
});

router.get('/logout', async (ctx, next) => {
    try {
        var token = ctx.session.token;
        var csrfToken = ctx.session.userConfirmCsrfToken.token;
        console.log(`[client /logout] ctx.session: ${JSON.stringify(ctx.session)}`)
        console.log(`[client /logout] csrfToken: ${JSON.stringify(csrfToken)}`)
        resp = await httpUtils.getWithToken(oauthServerInfo.endpoint.authorize + '&logout=true&csrfToken=' + csrfToken, {
            token: token.accessToken,
            type: token.tokenType
        });
        console.log(`[client /logout] response: ${JSON.stringify(resp)}`)
    } catch (e) {
        console.log(`[client /logout] ERROR: ${e}`)
    }
    ctx.session = null;
    return ctx.render("dino_home");
});

router.get('/register', async (ctx, next) => {
    var token = ctx.session.token,
        refresh = false,
        resp;

    var oauthState = {
        state: `os-${Math.floor(Math.random() * 1000)}`,
        expiresAt: Date.now() + OAUTH_STATE_EXPIRES_IN
    };

    ctx.session.oauthState = oauthState;

    if (!token) {
        // ctx.session = null;
        redirect(ctx, oauthServerInfo.endpoint.register, {});
    } else {
        return ctx.render("dino_home");
    }
})


router.get('/login', async (ctx, next) => {
    var token = ctx.session.token,
        refresh = false,
        resp;

    if (token && !isExpired(token.expiresAt)) {
        try {
            console.log(`[login] token.type: ${token.type} token.token: ${token.token}`)
            resp = await httpUtils.getWithToken(oauthServerInfo.api.getUserInfo, {
                token: token.accessToken,
                type: token.tokenType
            });
            if (resp.response.statusCode === 200) {
                //return ctx.body = resp.body;
                return ctx.render("dino_home");

            } else if (resp.response.statusCode === 401) {
                //maybe the access token expired, try to use the refresh token to get a new one
                refresh = true;
            } else {
                throw new Error(`error-code:${resp.response.statusCode}`);
            }
        } catch (e) {
            return ctx.body = { error: e };
        }
    }
    if (!token) {
        return redirectToAuthorize(ctx);
    }
    if (!refresh) {
        ctx.body = { error: 'unknown error' };
        return redirectToAuthorize(ctx);
    }
    token = await refreshToken(token);
    if (token) {
        ctx.session.token = token;
        //refresh success, try again
        ctx.redirect(`${ctx.href}`);
    } else {
        //fail to refresh, maybe the refresh token itself expired
        //ctx.session = null;
        return redirectToAuthorize(ctx);
    }
});

router.get('/home', async (ctx, next) => {
    var token = ctx.session.token,
        refresh = false,
        resp;

    if (token && !isExpired(token.expiresAt)) {
        try {
            console.log(`[home] token.type: ${token.type} token.token: ${token.token}`)
            resp = await httpUtils.getWithToken(oauthServerInfo.api.home, {
                token: token.accessToken,
                type: token.tokenType
            });
            //await forwardToView(ctx, 'home', resp);
            console.log(`[home] resp: ${resp.response.statusCode}`)
            if (resp.response.statusCode === 200) {
                //return ctx.body = resp.body;
                //return ctx.render("dinos", { attributes: resp.body.result });
                return ctx.render("dino_home")
            } else if (resp.response.statusCode === 401) {
                //maybe the access token expired, try to use the refresh token to get a new one
                refresh = true;
            } else {
                console.log(`[home] error-code:${resp.response.statusCode}`);
                throw new Error(`error-code:${resp.response.statusCode}`);
            }
        } catch (e) {
            console.log('[home] catch error')
            return ctx.body = { error: e };
        }
    }
    if (!token) {
        console.log(`[home] no token`)
        return redirectToAuthorize(ctx);
    }
    if (!refresh) {
        console.log(`[home] refresh = false`)
        return ctx.body = { error: 'unknown error' };
    }
    token = await refreshToken(token);
    console.log(`[home] refresh = false`)
    if (token) {
        ctx.session.token = token;
        //refresh success, try again
        ctx.redirect(`${ctx.href}`);
    } else {
        //fail to refresh, maybe the refresh token itself expired
        ctx.session.token = null;
        return redirectToAuthorize(ctx);
    }
});


//endpoint to receive authorization code
//Note: the oauth server do not directly call this endpoint, instead, it ask the user agent (browser) to redirect here
router.get('/receiveGrant', async (ctx, next) => {
    var { code, state } = ctx.query,
        oauthState = ctx.session.oauthState,
        resp;

    if (code && state && oauthState &&
        oauthState.state == state &&
        !isExpired(oauthState.expiresAt)) {
        //confirm that this request is valid (not forged)
        //use the code to request for an access token
        console.log(`[receiveGrant] code: ${code}, state: ${state}`)
        try {
            resp = await httpUtils.postForm(oauthServerInfo.endpoint.token, {
                'grant_type': oauthClientInfo.grantType,
                'client_id': oauthClientInfo.id,
                'client_secret': oauthClientInfo.clientSecret,
                'code': code,
                'scope': oauthClientInfo.scope,
                'redirect_uri': oauthClientInfo.redirectUri
            });
            if (resp.response.statusCode !== 200) {
                throw new Error(`error-code: ${resp.response.statusCode}`);
            }
            //in the example, we will save token information in session
            //in production environment, you may need them stored in persistent storage like a database
            ctx.session.token = {
                'accessToken': resp.body.access_token,
                'refreshToken': resp.body.refresh_token,
                'tokenType': resp.body.token_type,
                'expiresAt': Date.now() + resp.body.expires_in * 1000//when the access token will expire
            };
            // redirect straight to home.html
            // return await forwardToView(ctx, 'oauth-success', {});
            return ctx.render("dino_home")
            //return await forwardToView(ctx, 'home', {});
        } catch (e) {
            //maybe the code expired
            console.error(e);
            //ask user to authorize again
        }
    }
    redirectToAuthorize(ctx);
});

router.get('/list_dinos', async (ctx, next) => {
    var token = ctx.session.token,
        refresh = false,
        resp;

    if (token && !isExpired(token.expiresAt)) {
        try {
            resp = await httpUtils.getWithToken(oauthServerInfo.api.listDinos, {
                token: token.accessToken,
                type: token.tokenType
            });
            //console.log(resp)
            if (resp.response.statusCode === 200) {
                return ctx.render("dinos", {
                    dinos: resp.body.result,
                    update_time: Date(Date.now())
                });
            } else if (resp.response.statusCode === 401) {
                //maybe the access token expired, try to use the refresh token to get a new one
                refresh = true;
            } else {
                throw new Error(`error-code:${resp.response.statusCode}`);
            }
        } catch (e) {
            return ctx.body = { error: e };
        }
    }
    if (!token) {
        return redirectToAuthorize(ctx);
    }
    if (!refresh) {
        return redirectToAuthorize(ctx);
    }
    token = await refreshToken(token);
    if (token) {
        ctx.session.token = token;
        //refresh success, try again
        ctx.redirect(`${ctx.href}`);
    } else {
        //fail to refresh, maybe the refresh token itself expired
        ctx.session.token = null;
        return redirectToAuthorize(ctx);
    }
});


router.get('/buy_flagosaurus', async (ctx, next) => {
    var token = ctx.session.token,
        refresh = false,
        resp;

    console.log(`[client.js] /buy_flagosaurus \nctx: ${JSON.stringify(ctx)} \nsession:${JSON.stringify(ctx.session)}\ntoken: ${JSON.stringify(token)}`)
    if (token && !isExpired(token.expiresAt)) {
        try {
            resp = await httpUtils.getWithToken(oauthServerInfo.api.buyFlagosaurus, {
                token: token.accessToken,
                type: token.tokenType
            });
            if (resp.response.statusCode === 200) {
                return ctx.body = resp.body;

            } else {
                throw new Error(`error-code:${resp.response.statusCode}`);
            }
        } catch (e) {
            return ctx.body = { error: 'Insufficient scope: authorized scope is insufficient' };
        }
    }
    if (!token) {
        return redirectToAuthorize(ctx);
    }
    if (!refresh) {
        //return ctx.body = { error: 'unknown error' };
        return redirectToAuthorize(ctx);
    }
    token = await refreshToken(token);
    if (token) {
        ctx.session.token = token;
        //refresh success, try again
        ctx.redirect(`${ctx.href}`);
    } else {
        //fail to refresh, maybe the refresh token itself expired
        ctx.session.token = null;
        return redirectToAuthorize(ctx);
    }
});


router.get('/buy_dino', async (ctx, next) => {
    var token = ctx.session.token,
        refresh = false,
        resp;

    if (token && !isExpired(token.expiresAt)) {
        try {
            resp = await httpUtils.getWithToken(oauthServerInfo.api.buyDino, {
                token: token.accessToken,
                type: token.tokenType
            });
            if (resp.response.statusCode === 200) {
                return ctx.render("buy_page", {
                    dinos: resp.body.result.dinos,
                    balance: resp.body.result.detail.balance,
                    user: resp.body.result.detail.username,
                    portfolio: resp.body.result.detail.portfolio
                });
            } else if (resp.response.statusCode === 401) {
                //maybe the access token expired, try to use the refresh token to get a new one
                refresh = true;
            } else {
                throw new Error(`error-code:${resp.response.statusCode}`);
            }
        } catch (e) {
            return ctx.body = { error: e };
        }
    }
    if (!token) {
        return redirectToAuthorize(ctx);
    }
    if (!refresh) {
        return redirectToAuthorize(ctx);
    }
    token = await refreshToken(token);

    if (token) {
        ctx.session.token = token;
        //refresh success, try again
        ctx.redirect(`${ctx.href}`);
    } else {
        //fail to refresh, maybe the refresh token itself expired
        ctx.session.token = null;
        return redirectToAuthorize(ctx);
    }
});


// catch everything and redirect to 'dinomarket_app'
router.all('/*', async (ctx, next) => {
    //await forwardToView(ctx, 'dinomarket_app', {})
    //await forwardToView(ctx, 'dino_home', {})
    console.log(`[client.js] /* hit`)
    return ctx.render("dino_home");
});

async function refreshToken(token) {
    var resp;

    try {
        resp = await httpUtils.postForm(oauthServerInfo.endpoint.token, {
            'grant_type': 'refresh_token',
            'client_id': oauthClientInfo.id,
            'client_secret': oauthClientInfo.clientSecret,
            'refresh_token': token.refreshToken,
            'scope': oauthClientInfo.scope,
            'redirect_uri': oauthClientInfo.redirectUri
        });

        if (resp.response.statusCode !== 200) {
            return false;
        }
        if (!resp.body.access_token) {
            throw new Error(`unkown error, no access_token in response`);
        }

        //in the example, we will save token information in session
        //in production environment, you may need them stored in persistent storage like a database
        token = {
            'accessToken': resp.body.access_token,
            'refreshToken': resp.body.refresh_token,
            'tokenType': resp.body.token_type,
            'expiresAt': Date.now() + resp.body.expires_in * 1000//when the access token will expire
        };

        return token;
    } catch (e) {
        console.error(e);
        return false;
    }
}

async function forwardToView(ctx, viewName, viewModel) {
    var viewPath = path.resolve(`${templateConfig.basePath}`, `${viewName}.${templateConfig.ext}`),
        renderer = consolidate[templateConfig.engine];

    if (!renderer) {
        throw new Error(`template engine ${templateConfig.engine} is unsupported`);
    }

    ctx.body = await renderer(viewPath, viewModel);
}

function redirectToAuthorize(ctx) {
    // console.log('redirectToAuthorize')
    var oauthState = {
        state: `os-${Math.floor(Math.random() * 1000)}`,
        expiresAt: Date.now() + OAUTH_STATE_EXPIRES_IN
    };

    ctx.session.oauthState = oauthState;
    console.log(`[redirectToAuthorize] oauthState: ${ctx.session.oauthState}, token: ${ctx.session.token}`)

    redirect(ctx, oauthServerInfo.endpoint.authorize, {
        'response_type': oauthClientInfo.responseType,
        'client_id': oauthClientInfo.id,
        'scope': oauthClientInfo.scope,
        'redirect_uri': oauthClientInfo.redirectUri,
        'state': oauthState.state
    });
}

function isExpired(time) {
    return Date.now() > time;
}

function redirect(ctx, uri, query = {}) {
    console.log(`[client.js] redirect() hit`)
    ctx.redirect(composeUri(uri, query));
}

function composeUri(uri, query) {
    var f, s, arr;

    arr = [];

    for (f in query) {
        if (typeof query.hasOwnProperty != 'function' || query.hasOwnProperty(f)) {
            arr.push(`${f}=${encodeURIComponent(query[f])}`);
        }
    }

    s = arr.join('&');

    if (s && !/\?$/.test(uri)) {
        s = '?' + s;
    }

    return `${uri}${s}`;
}

app.use(bodyParser());
app.use(validator({
    customValidators: {
        isBtw10: (val) => val >= 0 && val < 10
    }
}));
app.use(session(KOA_SESSION_CONFIG, app));
app.use(router.routes());

app.listen(3001, function () {
    console.log('oauth client listening on port 3001');
    console.log(`please visit http://${host}:3001/dinomarket_app`);
});
