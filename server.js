var express = require('express');
var app = express();
var exec = require('child_process').exec;
const config = require('./package.json').nofstack;

const main = './' + config.mainOut;

const port = 8080;

function handleRequest(request, response){
  exec(main + ' ' + request.url, (error, stdout, stderr) => {
    response.setHeader('Content-Type', 'text/html');

    var output = stdout;
    if ( error ) output = error;
    if ( stderr ) output = stderr;
    response.end(output);
  });
}

// Serve static content from the public folder if its available
app.use(express.static('public'));

// Wildcard routing so that the request can be handled correctly
app.get(/^(.*)$/, handleRequest);

var server = app.listen(port, () => {
  console.log(`Server listening on: http://localhost:${port}`);
});
