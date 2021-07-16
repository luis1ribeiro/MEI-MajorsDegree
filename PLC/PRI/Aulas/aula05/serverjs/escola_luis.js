var http = require('http')
var fs = require('fs')
const axios = require('axios')

var serv = http.createServer(function (req,res){
    console.log(req.method + ' ' + req.url);
    //qual o método
    if(req.method == 'GET') {
        if(req.url == '/'){
            res.writeHead(200, {
                'Content-Type': 'text/html; charset=utf-8'
            })
            res.write('<p>ESCOLA DE MÚSICA</p>');
            res.write('<ul>');
            res.write('<li><a href=\"http://localhost:3001/alunos\">Lista de alunos</a></li>');
            res.write('</ul>');
            res.end();    
        }
        else if(req.url == '/alunos') {
            res.writeHead(200, {
                'Content-Type': 'text/html; charset=utf-8'
            })
            axios.get('http://localhost:3000/alunos')
                .then(resp => {
                    alunos = resp.data;

                    res.write('<ul>');
                    alunos.forEach(a => {
                        res.write(`<li> ${a.id}, ${a.nome}, ${a.instrumento} </li>`)
                        //console.log(`${a.id}, ${a.nome}, ${a.instrumento}`);
                        res.end();
                    });
                    res.write('</ul>');
                }).catch(error => {
                    console.log('ERRO: ' + error);
                    res.write('<p>Não consegui obter a lista de alunos.</p>');
                    res.end();
            });
        }
    }
    else{
        res.writeHead(200, {
            'Content-Type': 'text/html'
        })
        res.write('<p>Pedido não suportado: ' + req.method + '</p>');
        res.end();
    }
});

serv.listen(3001);
console.log('Servidor à escuta na porta 3001...');