var http = require('http');
var fs = require('fs');
var url = require('url');

var server = http.createServer(function(req, res) {
    try {
        var path = url.parse(req.url, true).query;
        path = path['path'];
        var no_ext = path.substring(0, path.length - 4);
        var ext = path.substring(path.length - 4, path.length);
        console.log(path);
        console.log(no_ext);
        console.log(ext);
        if (no_ext.indexOf(".") == -1 && path.indexOf("Ｎ") == -1 && path.indexOf("%") == -1 && ext == '.txt') {
            var base = "http://localhost:8080/poems/";
            var callback = function(response){
                var str = '';
                response.on('data', function (chunk) {
                    str += chunk;
                });
                response.on('end', function () {
                  res.end(str);
                });
            }
            http.get(base + path, callback).end();
        } else {
            res.writeHead(403);
            res.end("WHOA THATS BANNED!!!!");
        }
    }
    catch (e) {
        res.writeHead(404);
        res.end('Oops');
    }
});
server.listen(9999);