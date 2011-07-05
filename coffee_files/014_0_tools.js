(function() {
  var http;
  http = require('http');
  http.createServer(function(req, res) {
    console.log('%s %s', req.method, req.url);
    res.writeHead(200);
    return res.end('Hello World2');
  }).listen(4000);
}).call(this);
