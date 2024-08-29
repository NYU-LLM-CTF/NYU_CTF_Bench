const crypto = require("crypto");

exports.hash_password = (password) => {
    let hash = crypto.createHash('sha256').update(password).digest('hex');
    return hash;
}
