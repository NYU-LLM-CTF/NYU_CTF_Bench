const host = process.env.HOST;

const dinomaster_app = {
	'id': 'dinomaster_app',
	'clientSecret': 'this_is_the_dinomaster_client_secret',
	'name': 'Dinomaster App',
	'scope': 'user_info:read,list_dinos,buy_dino,sell_dino,buy_flagosaurus',
	'grants': ['authorization_code', 'refresh_token'],
	'redirectUris': [`http://${host}:3001/receiveGrant`],
	'accessTokenLifetime': 3600 * 72, // 72 hrs, not required, default is 3600,
	'refreshTokenLifetime': 3600 * 24 * 30 //not required, default is 2 weeks
};

const dinomarket_app = {
	'id': 'dinomarket_app',
	'clientSecret': 'this_is_the_dinomarket_secret',
	'name': 'Dinomarket App',
	'scope': 'user_info:read,list_dinos,buy_dino,sell_dino',
	'grants': ['authorization_code', 'refresh_token'],
	'redirectUris': [`http://${host}:3001/receiveGrant`],
	'accessTokenLifetime': 7200, //not required, default is 3600,
	'refreshTokenLifetime': 3600 * 24 * 30 //not required, default is 2 weeks
};

const registry = {
	clients: {
		'dinomarket_app': dinomarket_app,
		'dinomaster_app': dinomaster_app
	},
	scopes: {
		'user_info:read': {
			'desc': 'read user information'
		},
		'list_dinos': {
			'desc': 'list the dinos for sale'
		},
		'buy_dino': {
			'desc': 'buy a dino'
		},
		'sell_dino': {
			'desc': 'sell a dino'
		},
		'buy_flagosaurus': {
			'desc': 'FLAG'
		}
	}
};

module.exports = registry;