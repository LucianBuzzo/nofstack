var http = require('http');
var exec = require('child_process').exec;
var config = require('./package.json').nofstack;

var main = './' + config.mainOut;

var PORT = 8080;

function handleRequest(request, response){
  exec(main + ' ' + request.url, function(error, stdout, stderr) {
    response.setHeader('Content-Type', 'text/html');
    response.end(stdout);
  });
}

var server = http.createServer(handleRequest);

server.listen(PORT, function(){
  console.log("Server listening on: http://localhost:%s", PORT);
});
