const makeRequest = require('request');

module.exports.getWithToken = function (url, token) {
	console.log(`[http-utils getWithToken] url: ${url}, token ${token}`)
	return new Promise((resolve, reject) => {
		makeRequest({
			url: url,
			rejectUnauthorized: false,
			headers: {
				'Authorization': `${token.type} ${token.token}`
			}
		}, function (error, response, body) {
			if (error) {
				reject(error);
				return;
			}

			if (/json/i.test(response.headers['content-type'])) {
				response.body = JSON.parse(body);
			}

			resolve({
				'response': response,
				'body': response.body
			});
		});
	});
}

module.exports.postForm = function (url, formData, headers) {
	return new Promise((resolve, reject) => {
		makeRequest.post({
			url: url,
			headers: headers || {},
			form: formData,
			rejectUnauthorized: false
		}, (error, response, body) => {
			if (error) {
				reject(error);
				return;
			}
			if (/json/i.test(response.headers['content-type'])) {
				response.body = JSON.parse(body);
			}
			resolve({
				'response': response,
				'body': response.body
			});
		});
	});
}