var http = require('http')
var fs = require('fs')

var serv = http.createServer(function (req,res){

    var size = req.url.split("/").length

    if (req.url.match(/\/arqs\/arq[0-9]{1,3}.html/)) {
        var mySubString = req.url.substring(
            req.url.lastIndexOf("q") + 1,
            req.url.lastIndexOf(".")
        );
        req.url = '/arqs/' + mySubString
        console.log(req.url + " ")
    }

    if (req.url.match(/\/arqs\/index.html/)) {
        req.url = '/arqs/*'
    }

    var nmr = req.url.split("/")[2];

    if (parseInt(nmr) < 123 && size == 3) {
        if (req.url.match(/\/arqs\/([0-9]{2})?[0-9]/)) {
            fs.readFile('./arqs/arq' + nmr + '.html', function(err,data){
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
    }
    else if (size == 3 && req.url.match(/\/arqs\/[*]/)){
        fs.readFile('./arqs/index.html', function(err,data){
            res.writeHead(200, {'Content-Type': 'text/html'});
            res.write(data);
            res.end();
        });
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
