
module.exports = OauthModel;

/**
 * A model that implements parts of the Model Specification(http://oauth2-server.readthedocs.io/en/latest/model/spec.html). <br/>
 * This model is sufficient for the 'authorization code' authorization type as well as both 'code' and 'refresh_token' token grant types
 * @param {Object} options - options
 * @param {Object} options.authorizationCode - storage for storing authorziation codes
 * @param {Object} options.accessTokenStore - stroage for storing access tokens
 * @param {Object} options.refreshTokenStore - storage for storing refresh tokens
 */
function OauthModel(options = {}) {
	if (!(this instanceof OauthModel)) {
		return new OauthModel(options);
	}

	if (!(options.authorizationCodeStore ||
		options.accessTokenStore ||
		options.refreshTokenStore ||
		options.clientRegistry)) {
		throw "stores or client registry not provided";
	}

	var self = this;

	self.authorizationCodeStore = options.authorizationCodeStore;
	self.accessTokenStore = options.accessTokenStore;
	self.refreshTokenStore = options.refreshTokenStore;
	self.clientRegistry = options.clientRegistry;

	return self;
}

//We list all the api described in the Model Specification but implement only those we need.
//Model mothods can either receive a callback or return a Promise(or use async/await).
//In this example, we use async/await.

/**
 * not implemented, use default
 */
OauthModel.prototype.generateAccessToken = undefined;

/**
 * not implemented, use default
 */
OauthModel.prototype.generateRefreshToken = undefined;

/**
 * not implemented, use default
 */
OauthModel.prototype.generateAuthorizationCode = undefined;

/**
 * the node-oauth2-server use this method to get detail infomation of an access token previously stored used OauthModel.prototype.saveToken
 * @param {String} accessToken - the access token string
 * @return {Object} token - the access token object, containing (at least) the following infomation, or null if the access token desen't not exist:
 *         {String} token.accessToken - the access token string
 *         {Date} token.accessTokenExpiresAt - the exact time when the access token should expire
 *         {String} token.scope - access scope of this access token
 *         {Object} token.client - the oauth client
 *         {String} token.client.id - string id of the oauth client
 *         {Object} token.user - the user which this access token represents, this data structure of the user object is not part of the Model Specification, and what it should be is completely up to you. In this example, we use { username: 'someUserName' } where the 'username' field is used to uniquely identify an user in the user database.
 */
OauthModel.prototype.getAccessToken = async function (accessToken) {
	var self = this,
		token = self.accessTokenStore.get(accessToken),
		client, user;

	if (!token) {
		return null;
	}

	// THIS IS BROKEN
	//token.client = { id: token.client };
	//token.user = { username: token.user };

	console.log(`[model.js] getAccessToken: ${JSON.stringify(token)}`)

	return token;
};

/**
 * the node-oauth2-server use this method to get detail information of a refresh token previously stored used OauthModel.prototype.saveToken.
 * <b>Note:</b>refresh token is used by the oauth client to request for a new access token, and it's actually not related to any access token in any way, so access tokens and refresh tokens should be stored and retrieved independent to each other.
 * @param {String} refreshToken - the refresh token string
 * @return {Object} token - the token object containing (at least) the following infomation, or null if the refresh token doesn't exist:
 *        {String} token.refreshToken - the refresh token string
 *        {Date} token.refreshTokenExpiresAt - the exact time when the refresh token should expire
 *        {String} scope - the access scope
 *        {Object} client - the client object
 *        {String} client.id - the id of the client
 *        {Object} user - the user object
 *        {String} user.username - identifier of the user
 */
OauthModel.prototype.getRefreshToken = async function (refreshToken) {
	var self = this,
		token = self.refreshTokenStore.get(refreshToken),
		client, user;

	if (!token) {
		return null;
	}

	// THIS IS BROKEN
	//token.client = { id: token.client };
	//token.user = { username: token.user };

	console.log(`[model.js] getRefreshToken: ${JSON.stringify(token)}`)

	return token;
};

/**
 * the node-oauth2-server use this method to get detail information of a authorization code previously stored used OauthModel.prototype.saveAuthorizationCode.
 * @param {String} authorizationCode - the authorization code string
 * @return {Object} code - the code object containing the following information, or null if the authorization code doesn't exist
 *         {String} code - the authorization code string
 *         {Date} expiresAt - the exact time when the code should expire
 *         {String} redirectUri - the redirect_uri query parameter of the '/oauth/authorize' request, indicating where to redirect to with the code
 *         {String} scope - the authorization scope deciding the access scope of the access token requested by the oauth client using this code
 *         {Object} client - the client object
 *         {String} client.id - the client id
 *         {Object} user - the user object
 *         {String} user.username - the user identifier
 */
OauthModel.prototype.getAuthorizationCode = async function (authorizationCode) {
	var self = this,
		code = self.authorizationCodeStore.get(authorizationCode),
		client, user;

	if (!code) {
		return null;
	}

	code.client = { id: code.client };
	code.user = { username: code.user };

	console.log(`[model.js] getAuthorizationCode: ${JSON.stringify(code)}`)

	return code;
};

/**
 * the node-oauth2-server use this method to get detail infomation of a registered client.
 * @param {String} clientId - the client id
 * @param {String} [clientSecret] - the client secret, used in the token granting phase to authenticate the oauth client
 * @return {Object} client - the client object, containing (at least) the following infomation, or null if the client is not a valid registered client or the client secret doesn't match the clientId:
 *         {String} client.id - the client id
 *         {Array<String>} grants - an array of grant types allowed for this client, allowed values are: authorization_code | client_credentials | password | refresh_token
 *         {Array<String>} redirectUris - an array of urls (of the client) that allowed for redirecting to by the oauth server
 *         {Number} [accessTokenLifetime=3600] - define the lifetime of an access token in seconds, default is 1 hour
 *         {Number} [refreshTokenLifetime=3600 * 24 * 14] - define the lifetime of an refresh token in seconds, default is 2 weeks

 */
OauthModel.prototype.getClient = async function (clientId, clientSecret) {
	var self = this,
		registry = self.clientRegistry,
		client;

	client = registry.clients[clientId];

	if (!client) {
		return null;
	}

	//the clientSecret is not needed in the 'authorize' phase using 'code' response type
	if (clientSecret && client.clientSecret != clientSecret) {
		return null;
	}

	return client;
};

// not implemented, only needed when using 'password' grant type
OauthModel.prototype.getUser = null;

// not implemented, only needed when using 'client_credentials' grant type
OauthModel.prototype.getUserFromClient = null;

/**
 * the node-oauth2-server uses this method to save an access token and an refresh token(if refresh token enabled) during the token granting phase.
 * @param {Object} token - the token object
 * @param {String} token.accessToken - the access token string
 * @param {Date} token.accessTokenExpiresAt - @see OauthModel.prototype.getAccessToken
 * @param {String} token.refreshToken - the refresh token string
 * @param {Date} token.refreshTokenExpiresAt - @see OauthModel.prototype.getRefreshToken
 * @param {String} token.scope - the access scope
 * @param {Object} client - the client object - @see OauthModel.prototype.getClient
 * @param {String} client.id - the client id
 * @param {Object} user - the user object @see OauthModel.prototype.getAccessToken
 * @param {String} username - the user identifier
 * @return {Object} token - the token object saved, same as the parameter 'token'
 */
OauthModel.prototype.saveToken = async function (token, client, user) {
	var self = this,
		commonInfo, accessTokenToSave, refreshTokenToSave;

	//Note: we save the client id and username rather than the client and user objects, so when we retrieve the token from the store, we should convert them back to objects.
	commonInfo = {
		'client': client.id,
		'user': user.username,
		'scope': token.scope
	};

	accessTokenToSave = {
		'accessToken': token.accessToken,
		'accessTokenExpiresAt': token.accessTokenExpiresAt
	};

	Object.assign(accessTokenToSave, commonInfo);

	self.accessTokenStore.setExpiration(accessTokenToSave.accessToken, accessTokenToSave, accessTokenToSave.accessTokenExpiresAt);

	if (token.refreshToken) {
		refreshTokenToSave = {
			'refreshToken': token.refreshToken,
			'refreshTokenExpiresAt': token.refreshTokenExpiresAt
		};

		Object.assign(refreshTokenToSave, commonInfo);

		self.refreshTokenStore.setExpiration(refreshTokenToSave.refreshToken, refreshTokenToSave, refreshTokenToSave.refreshTokenExpiresAt);
	}

	token = Object.assign({}, token, commonInfo);

	console.log(`[model.js] saveToken: ${JSON.stringify(token)}`)

	return token;
};

/**
 * the node-oauth2-server uses this method to save an authorization code.
 * @param {Object} code - the authorization code object
 * @param {String} code.authorizationCode - the authorization code string
 * @param {Date} code.expiresAt - the time when the code should expire
 * @param {String} code.redirectUri - where to redirect to with the code
 * @param {String} [code.scope] - the authorized access scope
 * @param {Object} client - the client object
 * @param {String} client.id - the client id
 * @param {Object} user - the user object
 * @param {String} user.username - the user identifier
 * @return {Object} code - the code object saved
 */
OauthModel.prototype.saveAuthorizationCode = async function (code, client, user) {
	var self = this,
		codeToSave;

	codeToSave = {
		'authorizationCode': code.authorizationCode,
		'expiresAt': code.expiresAt,
		'redirectUri': code.redirectUri,
		'scope': code.scope,
		'client': client.id,
		'user': user.username
	};

	self.authorizationCodeStore.setExpiration(codeToSave.authorizationCode, codeToSave, codeToSave.expiresAt);

	code = Object.assign({}, code, {
		'client': client.id,
		'user': user.username
	});

	console.log(`[model.js] saveAuthorizationCode: ${JSON.stringify(code)}`)

	return code;
};

/**
 * the node-oauth2-server uses this method to revoke a refresh token(remove it from the store).
 * Note: by default, the node-oauth2-server enable the option 'alwaysIssueNewRefreshToken', meaning that every time you use a refresh token to get a new access token, the refresh token itself will be revoked and a new one will be issued along with the access token (you can set the option through OAuth2Server.token(request, response, [options], [callback]) or KoaOAuthServer.token(options)).
 * If you always use the refresh token before it expires, then there will always be a valid refresh token in the store(unless you explictly revoke it). This makes it seem like refresh token never expires.
 * @param {Object} token - the token object
 * @param {String} token.refreshToken - the refresh token string
 * @param {Date} token.refreshTokenExpiresAt - the exact time when the refresh token should expire
 * @param {String} token.scope - the access scope
 * @param {Object} token.client - the client object
 * @param {String} token.client.id - the client id
 * @param {Object} token.user - the user object
 * @param {String} token.user.username - the user identifier
 * @return {Boolean} - true if the token was successfully revoked, false if the token cound not be found
 */
OauthModel.prototype.revokeToken = async function (token) {
	var self = this,
		rs = self.refreshTokenStore.remove(token.refreshToken);

	return rs;
};

/**
 * the node-oauth2-server uses this method to revoke a authorization code(mostly when it expires)
 * @param {Object} code - the authorization code object
 * @param {String} authorizationCode - the authorization code string
 * @param {Date} code.expiresAt -the time when the code should expire
 * @param {String} code.redirectUri - the redirect uri
 * @param {String} code.scope - the authorization scope
 * @param {Object} code.client - the client object
 * @param {String} code.client.id - the client id
 * @param {Object}  code.user - the user object
 * @param {String} code.user.username - the user identifier
 * @return {Boolean} - true if the code is revoked successfully,false if the could not be found
 */
OauthModel.prototype.revokeAuthorizationCode = async function (code) {
	var self = this,
		rs = self.authorizationCodeStore.remove(code.authorizationCode);

	return rs;
};

/**
 * the node-oauth2-server uses this method to determine what scopes should be granted to the client for accessing the user's data.
 * for example, the client requests the oauth server for an access token of the 'user_info:read,user_info_write' scope, 
 * but the oauth server determine by this method that only the 'user_info:read' scope should be granted.
 * @param {Object} user - the user whose data the client wants to access
 * @param {String} user.username - the user identifier
 * @param {Object} client - the oauth client
 * @param {String} client.id - the client id
 * @param {String} scope - the scopes which the client requested for
 * @return {String} validScopes - the actual valid scopes for the client, null if no valid scopes for the client
 */
OauthModel.prototype.validateScope = async function (user, client, scope) {
	if (!scope) {
		return null;
	}
	var self = this,
		validScopes, scopes;

	client = self.clientRegistry.clients[client.id];

	if (!client || !client.scope) {
		return null;
	}

	validScopes = client.scope.split(',').map(s => s.trim());
	scopes = scope.split(',').map(s => s.trim()).filter(s => validScopes.indexOf(s) >= 0);

	return scope.length ? scopes.join(',') : null;
};

/**
 * node-oauth2-server uses this method in authentication handler to verify whether an access token from a request is sufficient to the 'scope' declared for the requested resources
 * @param {Object} accessToken - the accessToken object
 * @param {String} accessToken.accessToken - the accessToken string
 * @param {Date} accessToken.accessTokenExpiresAt - the time when the token should expire
 * @param {String} accessToken.scope - the granted access scope of the token
 * @param {Object} accessToken.client - the client object
 * @param {String} accessToken.client.id - the client id
 * @param {Object} accessTokne.user - the user object
 * @param {String} accessToken.user.username - the user identifier
 * @param {String} scope - the scope declared for the resources
 * @return {Boolean} - true if the access token has sufficient access scopes for the resources
 */
OauthModel.prototype.verifyScope = async function (accessToken, scope) {
	var self = this,
		validScopes, scopes;

	if (!scope) {
		//no scope declared for the resource, free to access
		return true;
	}

	if (!accessToken.scope) {
		return false;
	}

	validScopes = scope.split(',').map(s => s.trim());

	scopes = accessToken.scope.split(',').map(s => s.trim());

	//check if at least one of the scopes granted to the access token are allowed to access the resource
	return scopes.some(s => validScopes.indexOf(s) >= 0);
};
