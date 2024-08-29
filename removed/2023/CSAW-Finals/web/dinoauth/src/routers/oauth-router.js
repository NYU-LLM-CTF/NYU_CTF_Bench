const oauthServer = require('koa2-oauth-server');
const bodyParser = require('koa-bodyparser');
const router = require('koa-router');
const simpleMemoryStore = require('simple-memory-storage');
const consolidate = require('consolidate');
const path = require('path');
const validator = require('koa-async-validator');

const userDb = require('../db/fake-user-db');
const oauthModel = require('../oauth-model/model');
const localFileClientRegistry = require('../oauth-model/client-registry');
let log = require('../db/log');

const host = process.env.HOST;

const CSRF_TOKEN_EXPIRES_IN = 1000 * 60 * 15;
const MAX_USERS = 1000;

const templateConfig = {
	'basePath': path.resolve(`${__dirname}/../views`),
	'ext': 'html',
	'engine': 'lodash'
};


module.exports = getOauthRouter;

function getOauthRouter(app, options = {}) {

	var oauthRouter = new router({ prefix: options.prefix });

	// app.use(async (ctx, next) => {
	// 	log.push({ ctx: JSON.stringify(ctx), body: JSON.stringify(ctx.request.body) })

	// 	await next()
	// });

	app.use(bodyParser());
	app.use(validator([]));

	app.oauth = new oauthServer({
		model: oauthModel({
			//in this example, we use runtime-memory-backed storage for oauth codes and tokens. 
			authorizationCodeStore: new simpleMemoryStore(),
			accessTokenStore: new simpleMemoryStore(),
			refreshTokenStore: new simpleMemoryStore(),
			clientRegistry: localFileClientRegistry
		}),
		useErrorHandler: true
	});


	oauthRouter.post('/login', login);

	//check if the user has logged, if not, redirect to login page 
	//otherwise redirect to the authorization confirm page
	oauthRouter.get('/authorize', checkLogin);

	//define the authorize endpoint, 
	//in this example, we implement only the most commonly used authorization type: authorization code
	oauthRouter.get('/authorize', app.oauth.authorize({
		//implement a handle(request, response):user method to get the authenticated user (aka. the logged-in user)
		//Note: this is where the node-oauth2-server get to know what the currently logined-in user is.
		authenticateHandler: authenticateHandler()
	}));

	//define the token endpoint, in this example, we implement two token grant types: 'code' and 'refresh_token'
	oauthRouter.post('/token', app.oauth.token());

	// register user endpoint
	oauthRouter.all('/register', async (ctx, next) => {
		console.log(`[register] ${ctx.session.oauthState}`)
		if (userDb.count() > MAX_USERS) {
			ctx.body = { 'error': 'Too many users registered.' }
			return;
		}
		ctx.sanitize('username').escape()
		ctx.sanitize('password').escape()

		var callbackUri = 'login',
			{ username, password } = ctx.request.body,
			user;

		if (username || password) {
			let e0 = ctx.assert('username', 'less than 16, gt 4')
				.len(4, 16)
				.validationErrors.length
			let e1 = ctx.assert('password', 'less than 16, gt 4')
				.len(4, 16)
				.validationErrors.length
			if ((e0 + e1) != 0) {
				ctx.body = { 'error': `[oauth-router] /register validation error: username and password must be btw 4-16 chars` }
				return;
			}
		}

		user = userDb.get(username);
		console.log(`[oauth-router] /register user: ${user}`)

		if (user) {
			ctx.body = { 'error': 'user is already registered' }
			return;
		};

		if (!username) {
			await forwardToView(ctx, 'register', {
				'callbackUri': callbackUri,
				'registerUrl': '/oauth/register'
			});
			return;
		} else {
			userDb.set(username, {
				'username': username,
				'password': password,
				'portfolio': [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
				'balance': '5'
			});
			console.log(`[oauth-router] /register: new user ${username} registered`);
			// ctx.redirect(`http://${host}:3001/registration_success`);
			r = await loginNoRedirect(ctx)
			state = ctx.session.oauthState;
			ctx.redirect(`/oauth/authorize?response_type=code&client_id=dinomarket_app&scope=user_info%3Aread%2Clist_dinos%2Cbuy_dino%2Csell_dino&redirect_uri=http%3A%2F%2F${host}%3A3001%2FreceiveGrant&state=${state.state}`)
		};

	});


	// debug endpoint
	oauthRouter.all('/debug', async (ctx, next) => {
		//leak client secret here
		ctx.status = 200;
		ctx.body = log;
	});

	//error handler
	oauthRouter.all('/*', async (ctx, next) => {
		var oauthState = ctx.state.oauth || {};
		var dummyStackTrace = new Error().stack;

		console.log(`[oauth-router /*] ctx: ${JSON.stringify(ctx)}`)
		console.log(`[oauth-router /*] stacktrace: ${dummyStackTrace}`)
		console.log(`[oauth-router /*] oauthState: ${JSON.stringify(oauthState)}`)

		if (oauthState.error) {
			//handle the error thrown by the oauth.authenticate middleware here
			ctx.throw(oauthState.error);
			return;
		} else {
			ctx.status = 404
			ctx.body = {
				'message': 'Something went wrong...check /debug for more information',
				'stacktrace': dummyStackTrace
			}
			return;
		}

		await next();
	});

	return oauthRouter;
}

function authenticateHandler() {
	return {
		handle: function (request, response) {
			//in this example, we store the logged-in user as the 'loginUser' attribute in session
			if (request.session.loginUser) {
				console.log(`[oauth-router authenticateHandler] code: ${JSON.stringify(request.session)}`)
				return { username: request.session.loginUser.username };
			}

			return null;
		}
	};
}

async function forwardToLogin(ctx, callbackUri) {
	await forwardToView(ctx, 'login', {
		//when logged in successfully, redirect back to the original request url
		'callbackUri': Buffer.from(callbackUri, 'utf-8').toString('base64'),
		'loginUrl': '/oauth/login'
	});
}

async function forwardToView(ctx, viewName, viewModel) {
	var viewPath = path.resolve(`${templateConfig.basePath}`, `${viewName}.${templateConfig.ext}`),
		renderer = consolidate[templateConfig.engine];

	if (!renderer) {
		throw new Error(`template engine ${templateConfig.engine} is unsupported`);
	}

	ctx.body = await renderer(viewPath, viewModel);
}

function getRequestUrl(ctx) {
	return `${ctx.href}`;
}

function removeUserAction(url) {
	return url.replace(/&?(deny|agree|logout|csrfToken)=[^&]+/g, '');
}

/**
 * @param {Date} time
 * @return {Boolean}
 */
function isExpired(time) {
	return Date.now() >= time;
}

async function checkLogin(ctx, next) {
	var agree = ctx.query.agree == 'true',
		deny = ctx.query.deny == 'true',
		logout = ctx.query.logout == 'true',
		clientId = ctx.query.client_id,
		{ csrfToken, scope } = ctx.query,
		loginUser = ctx.session.loginUser,
		sessCsrfToken = ctx.session.userConfirmCsrfToken,
		client, curRequestUrl, scopes;

	if (!clientId || !scope) {
		return ctx.status = 400;
	}

	client = localFileClientRegistry.clients[clientId];
	//in this example, we simply filter out those scopes that are not valid
	scopes = scope.split(',').map(s => localFileClientRegistry.scopes[s]).filter(Boolean);

	if (!client) {
		return ctx.status = 401;
	}

	curRequestUrl = removeUserAction(getRequestUrl(ctx));

	if (!loginUser) {
		return await forwardToLogin(ctx, curRequestUrl);
	}

	if (csrfToken && sessCsrfToken &&
		sessCsrfToken.token == csrfToken &&
		!isExpired(sessCsrfToken.expiresAt) &&
		(agree || deny || logout)) {
		if (deny) {
			await forwardToView(ctx, 'user-denied', {
				'clientName': client.name,
				'username': loginUser.username,
				'windowReplace': `http://${host}:3001/`
			});
		} else if (logout) {
			ctx.session.loginUser = null;
			return await forwardToLogin(ctx, curRequestUrl);
		} else {//agree
			console.log(`[oauth-router.checkLogin] agree clicked`)
			await next();
		}
		return;
	}

	sessCsrfToken = {
		'token': `csrf-${Math.floor(Math.random() * 100000000)}`,
		'expiresAt': Date.now() + CSRF_TOKEN_EXPIRES_IN
	};

	ctx.session.userConfirmCsrfToken = sessCsrfToken;

	await forwardToView(ctx, 'user-confirm', {
		'oauthUri': curRequestUrl,
		'csrfToken': sessCsrfToken.token,
		'clientName': client.name,
		'username': loginUser.username,
		'scopes': scopes
	});
}

async function login(ctx, next) {
	ctx.sanitize('username').escape()
	ctx.sanitize('password').escape()
	var callbackUri = ctx.request.body.callback_uri,
		{ username, password } = ctx.request.body,
		user;

	if (!callbackUri || !username || !password) {
		return ctx.status = 400;
	}

	callbackUri = Buffer.from(callbackUri, 'base64').toString('utf-8');

	user = userDb.get(username);
	console.log(`username: ${username}`)
	console.log(`password: ${password}`)
	console.log(`user: ${user}`)

	if (!user || user.password != password) {
		console.log("failed login");
		await forwardToLogin(ctx, callbackUri);
		return;
	}

	//login successfully
	console.log(`login success: ${username}`);
	ctx.session.loginUser = { 'username': username };

	ctx.redirect(callbackUri);
}

async function loginNoRedirect(ctx, next) {
	ctx.sanitize('username').escape()
	ctx.sanitize('password').escape()
	console.log(`ctx.session.oauthState ${JSON.stringify(ctx)}`)
	console.log(`ctx.session.oauthState ${JSON.stringify(ctx.session)}`)
	var callbackUri = ctx.request.body.callback_uri,
		{ username, password } = ctx.request.body,
		user;

	if (!callbackUri || !username || !password) {
		return ctx.status = 400;
	}

	callbackUri = Buffer.from(callbackUri, 'base64').toString('utf-8');

	user = userDb.get(username);
	console.log(`username: ${username}`)
	console.log(`password: ${password}`)
	console.log(`user: ${user}`)

	if (!user || user.password != password) {
		console.log("failed login");
		await forwardToLogin(ctx, callbackUri);
		return;
	}

	//login successfully
	console.log(`login success: ${username}`);
	ctx.session.loginUser = { 'username': username };

	// ctx.redirect(callbackUri);
}