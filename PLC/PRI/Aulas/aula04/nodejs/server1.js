var http = require('http')

http.createServer(function (req, res) {
    res.writeHead(200, { 'Content-type': 'text/plain' });
    res.end('Olá turma de 2020!');
}).listen(7777);
console.log('Servidor � escuta na porta 7777...')