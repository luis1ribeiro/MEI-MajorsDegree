var http = require('http')
const axios = require('axios');

var servidor = http.createServer(function (req, res) {
    console.log(req.method + ' ' + req.url)

    if (req.method == 'GET') {
        if (req.url == '/') {
            res.writeHead(200, {
                'Content-Type': 'text/html; charset=utf-8'
            })
            res.write('<h2>Escola de Música</h2>')
            res.write('<ul>')
            res.write('<li> <a href=\"http://localhost:3001/alunos\"> lista de alunos </a> </li>')
            res.write('</ul>')
            res.end()
        }
        else if (req.url == '/alunos') {
            axios.get('http://localhost:3000/alunos')
                .then(resp => {
                    res.writeHead(200, {
                        'Content-Type': 'text/html; charset=utf-8'
                    })
                    alunos = resp.data;
                    res.write('<ul>')
                    alunos.forEach(a => {
                        res.write(`<li> ${a.id}, ${a.nome}, ${a.instrumento} </li>`);
                    });
                    res.write('</ul>')
                    res.end();
                })
                .catch(error => {
                    console.log('ERRO: ' + error);
                    res.writeHead(200, {
                        'Content-Type': 'text/html'
                    })
                    res.write('<p>Não consegui obter a lista de alunos...</p>')
                    res.end()
                });
        }
    }
    else {
        res.writeHead(200, {
            'Content-Type': 'text/html'
        })
        res.write('<p>Pedido não suportado: ' + req.method + '</p>')
        res.end()
    }
})

servidor.listen(3001)
console.log('Servidor à escuta na porta 3001...')