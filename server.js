var http = require('http');
var exec = require('child_process').exec;
const config = require('./package.json').nofstack;

const main = './' + config.mainOut;

const port = 8080;

function handleRequest(request, response){
  exec(main + ' ' + request.url, (error, stdout, stderr) => {
    response.setHeader('Content-Type', 'text/html');
    response.end(stdout);
  });
}

var server = http.createServer(handleRequest);

server.listen(port, () => {
  console.log(`Server listening on: http://localhost:${port}`);
});
