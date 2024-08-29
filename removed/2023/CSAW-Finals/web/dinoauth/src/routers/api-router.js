const Router = require('koa-router');
const userDb = require('../db/fake-user-db');
const dinoDb = require('../db/dino-db');
const cron = require('node-cron');

module.exports = ApiRouter;

function ApiRouter(app, options = {}) {
    options = Object.assign({ prefix: '' }, options);

    var apiRouter = new Router({ prefix: options.prefix }),
        oauth = app.oauth;


    cron.schedule('* * * * *', () => {
        var dinos2price = dinoDb.get('dinos');
        for (let i = 0;  i < dinos2price.length ; i++) {
            delta = Math.floor(Math.random() * 10)
            if (Math.round(Math.random(),1)) {
                dinos2price[i].price += delta
            } else { 
               if (dinos2price[i].price - delta > 10) {
                dinos2price[i].price -= delta
               }
            }
        }
        console.log('changing dino price');
    })


    // scopes required for api-router
    apiRouter.get('/*', oauth.authenticate({ scope: 'user_info:read' }));
    apiRouter.get('/buy_dino', oauth.authenticate({ scope: 'buy_dino' }));
    apiRouter.get('/list_dinos', oauth.authenticate({ scope: 'list_dinos' }));
    apiRouter.get('/buy_flagosaurus', oauth.authenticate({ scope: 'buy_flagosaurus' }));

    //the error handler, need to set the koa2-oauth-server option 'useErrorHandler' to true, or errors won't be passed along the middleware chain
    apiRouter.all('/*', async (ctx, next) => {
        var oauthState = ctx.state.oauth || {};

        if (oauthState.error) {
            //handle the error thrown by the oauth.authenticate middleware here
            ctx.throw(oauthState.error);
            return;
        }

        if (oauthState.token) {
            //this means that the access token brought by the request is authenticated
            //for convinience, we put the user associated with the token in ctx.state.user
            ctx.state.user = oauthState.token.user;// => { username: 'the-username' }

            await next();
            return;
        }

        //should not reach here at all
        ctx.throw(new Error('unkown error'));
    });

    /**
     * OAuth Protected API
     */
    apiRouter.get('/buy_flagosaurus', async (ctx, next) => {
        flagosaurus = dinoDb.get('flagosaurus')

        //respond with the user's detail information
        ctx.body = {
            'success': true,
            'result': flagosaurus 
        };
    });

    /**
     * OAuth Protected API
     */
    apiRouter.get('/user', async (ctx, next) => {
        var user = ctx.state.user,
            detail = userDb.get(user);

        //delete detail.password;

        //respond with the user's detail information
        ctx.body = {
            'success': true,
            'result': detail
        };
    });

    /**
     * OAuth Protected API: home, in scope 'user_info:read'
     */
    apiRouter.get('/home', async (ctx, next) => {
        var user = ctx.state.user,
            detail = userDb.get(user);

        //delete detail.password;

        //respond with the user's detail information
        ctx.body = {
            'success': true,
            'result': detail
        };
    });

    /**
     * OAuth Protected API
     */
    apiRouter.get('/list_dinos', async (ctx, next) => {
        var user = ctx.state.user,
            detail = userDb.get(user);

        //delete detail.password;

        console.log(`[api-router/list_dinos] user: ${user}`)

        var dinos = dinoDb.get('dinos')

        ctx.body = {
            'success': true,
            'result': dinos
        };
    });


    /**
     * OAuth Protected API
     */
    apiRouter.get('/buy_dino', async (ctx, next) => {
        var user = ctx.state.user,
            detail = userDb.get(user);

        //delete detail.password;

        console.log(`[api-router /buy_dinos] user: ${JSON.stringify(user)}`)
        console.log(`[api-router /buy_dinos] detail: ${JSON.stringify(detail)}`)
         
        detail.dinos += 1;

        console.log(`[api-router /buy_dinos] dino+1: ${JSON.stringify(detail)}`)

        var dinos = dinoDb.get('dinos')
        
        ctx.body = {
            'success': true,
            'result': {dinos, detail}
        };
    });


    return apiRouter;
}
