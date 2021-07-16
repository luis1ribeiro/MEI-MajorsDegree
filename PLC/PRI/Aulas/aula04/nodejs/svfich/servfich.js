var http = require('http')
var fs = require('fs')

var serv = http.createServer(function (req,res){
    // ou req.url.split("/")[1]=="1"
    if (req.url.match(/\/[1-3]$/)) {
        var num = req.url.split("/")[1];
        fs.readFile('pag' + num + '.html', function(err,data){
            if (err){
                console.log("ERRO na leitura do ficheiro" + err);
                res.writeHead(200, {'Content-Type': 'text/html'});
                res.write("<p>Ficheiro inexistente.</p>");
                res.end()
            }
            else{
                res.writeHead(200, {'Content-Type': 'text/html'});
                res.write(data);
                res.end()
            }    
        })
    }
    else {
        // Falta tratar o favicon
        console.log("ERRO: Foi pedido um ficheiro não esperado");
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.write("<p>Ficheiro inexistente.</p>");
        res.end()
    }
});

serv.listen(7777);
console.log("Servidor à escuta na porta 7777...");