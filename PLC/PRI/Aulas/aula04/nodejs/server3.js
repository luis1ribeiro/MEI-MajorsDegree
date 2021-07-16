var http = require('http');
//var meta = require('./my-mod'); 


var servidor = http.createServer(function (req, res) {
    console.log(req.method + " " + req.url);
    res.writeHead(200, { 'Content-type': 'text/html; charset=utf-8' });
    // imprime o valor dos parametros (query string) -> o que vem a seguir ao '?'
    res.write(req.url);
    //console.dir(req);
    res.end();
});

servidor.listen(7777);
console.log('Servidor � escuta na porta 7777...')