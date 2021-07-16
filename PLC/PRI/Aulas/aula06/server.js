var http = require('http')
var axios = require('axios')
var fs = require('fs')

var static = require('./static.js')
//ir buscar apenas a função parse e var parse -> func parse
var {parse} = require('querystring')


// Funções auxilidares

// Ir ao body do Post buscar a info
function recuperaInfo(request, callback){
    if(request.headers['content-type'] == 'application/x-www-form-urlencoded'){
        let body = ''
        request.on('data', bloco => {
            body += bloco.toString()
        })
        request.on('end', ()=>{
            console.log(body)
            //chamo a função parse da querystring 
            callback(parse(body))
        })
    }
}
// POST Confirmation HTML Page Template -------------------------------------
function geraPostConfirm( aluno, d){
    return `
    <html>
    <head>
        <title>POST receipt: ${aluno.id}</title>
        <meta charset="utf-8"/>
        <link rel="icon" href="favicon.png"/>
        <link rel="stylesheet" href="w3.css"/>
    </head>
    <body>
        <div class="w3-card-4">
            <header class="w3-container w3-teal">
                <h1>Aluno ${aluno.id} inserido</h1>
            </header>

            <div class="w3-container">
                <p><a href="/alunos/${aluno.id}">Aceda aqui à sua página."</a></p>
            </div>

            <footer class="w3-container w3-teal">
                <address>Gerado por galuno::PRI2020 em ${d} - [<a href="/">Voltar</a>]</address>
            </footer>
        </div>
    </body>
    </html>
    `
}

// Template para a página com a lista de alunos ------------------
function geraPagAlunos( lista, d){
  let pagHTML = `
    <html>
        <head>
            <title>Lista de alunos</title>
            <meta charset="utf-8"/>
            <link rel="stylesheet" href="w3.css"/>
            <link rel="icon" href="favicon.png"/>
        </head>
        <body>
            <div class="w3-container w3-teal">
                <h2>
                    Lista de Alunos
                    <a href="/alunos/registo">
                    <button class="w3-btn w3-border w3-round-large w3-right">Adicionar</button>
                    </a>
                </h2>
            </div>
            <table class="w3-table w3-bordered">
                <tr>
                    <th>Nome</th>
                    <th>Número</th>
                    <th>Curso</th>
                </tr>
  `
  /* ----------------------------------------------------
     To be replaced with code to generate the table rows
                            |
                            V
     ---------------------------------------------------- */
    lista.forEach(a => {
        pagHTML += `
            <tr>
                <td><a href="/alunos/${a.id}"> ${a.nome} </a></td>
                <td>${a.id}</td>
                <td>${a.curso}</td>
            </tr>
        `
    });
  pagHTML += `
        </table>
        <div class="w3-container w3-teal">
            <address>Gerado por galuno::PRI2020 em ${d} --------------</address>
        </div>
    </body>
    </html>
  `
  return pagHTML
}

// Template para a página de aluno -------------------------------------
function geraPagAluno( aluno, d ){
    return `
    <html>
    <head>
        <title>Aluno: ${aluno.id}</title>
        <meta charset="utf-8"/>
        <link rel="stylesheet" href="w3.css"/>
        <link rel="icon" href="favicon.png"/>
    </head>
    <body>
        <div class="w3-card-4">
            <header class="w3-container w3-teal">
                <h1>Aluno ${aluno.id}</h1>
            </header>

            <div class="w3-container">
                <ul class="w3-ul w3-card-4" style="width:50%">
                    <li><b>Nome: </b> ${aluno.nome}</li>
                    <li><b>Número: </b> ${aluno.id}</li>
                    <li><b>Curso: </b> ${aluno.curso}</li>
                    <li><b>Git (link): </b> <a href="${aluno.git}">${aluno.git}</a></li>
                </ul>
            </div>

            <footer class="w3-container w3-teal">
                <address>Gerado por galuno::PRI2020 em ${d} - [<a href="/">Voltar</a>]</address>
            </footer>
        </div>
    </body>
    </html>
    `
}

// Template para o formulário de aluno ------------------
function geraFormAluno( d ){
    return `
    <html>
        <head>
            <title>Registo de um aluno</title>
            <meta charset="utf-8"/>
            <link rel="stylesheet" href="w3.css"/>
            <link rel="icon" href="favicon.png"/>
        </head>
        <body>
        
        </body>
            <div class="w3-container w3-teal">
                <h2>Registo de Aluno</h2>
            </div>

            <form class="w3-container" action="/alunos" method="POST"> 
                <label class="w3-text-teal"><b>Nome</b></label>
                <input class="w3-input w3-border w3-light-grey" type="text" name="nome">
          
                <label class="w3-text-teal"><b>Número / Identificador</b></label>
                <input class="w3-input w3-border w3-light-grey" type="text" name="id">

                <label class="w3-text-teal"><b>Curso</b></label>
                <input class="w3-input w3-border w3-light-grey" type="text" name="curso">

                <label class="w3-text-teal"><b>Link para o repositório no Git</b></label>
                <input class="w3-input w3-border w3-light-grey" type="text" name="git">
          
                <input class="w3-btn w3-blue-grey" type="submit" value="Registar"/>
                <input class="w3-btn w3-blue-grey" type="reset" value="Limpar valores"/> 
            </form>

            <footer class="w3-container w3-teal">
                <address>Gerado por galuno::PRI2020 em ${d}</address>
            </footer>
        </body>
    </html>
    `
}

// Criação do servidor

var galunoServer = http.createServer(function (req, res) {
    // Logger: que pedido chegou e quando
    var d = new Date().toISOString().substr(0, 16)
    console.log(req.method + " " + req.url + " " + d)

    // Tratamento do pedido -- Verificar se é um recurso estático
    if(static.recursoEstatico(req)){
        static.sirvoRecursoEstatico(req,res);
    }
    else{
        switch(req.method){
        case "GET": 
            // GET /alunos --------------------------------------------------------------------
            if((req.url == "/") || (req.url == "/alunos")){
                axios.get("http://localhost:3000/alunos?_sort=nome")
                    .then(response => {
                        var alunos = response.data

                        // Add code to render page with the student's list
                        res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                        // chama template em cima
                        res.write(geraPagAlunos(alunos, d))
                        res.end()
                    })
                    .catch(function(erro){
                        res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                        res.write("<p>Não foi possível obter a lista de alunos...")
                        res.end()
                    })
            }
            // GET /alunos/:id --------------------------------------------------------------------
            else if(/\/alunos\/(A|PG)[0-9]+$/.test(req.url)){
                var idAluno = req.url.split("/")[2]
                axios.get("http://localhost:3000/alunos/" + idAluno)
                    .then( response => {
                        let a = response.data
                        
                        // Add code to render page with the student record
                        res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'});
                        res.write(geraPagAluno(a, d));
                        res.end();
                    })
                    .catch(function(erro){
                        res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                        res.write("<p>Não foi possível obter o registo de aluno...")
                        res.end()
                    })
            }
            // GET /alunos/registo --------------------------------------------------------------------
            else if(req.url == "/alunos/registo"){
                // Add code to render page with the student form
                res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'});
                res.write(geraFormAluno(d));
                res.end();
            }
            // GET /w3.css ------------------------------------------------------------------------
            else if(/w3.css$/.test(req.url)){
                fs.readFile("./public/w3.css", function(erro, dados){
                    if(!erro){
                        res.writeHead(200, {'Content-Type': 'text/css;charset=utf-8'})
                        res.write(dados)
                        res.end()
                    }
                })
            }
            else{
                res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                res.write("<p>" + req.method + " " + req.url + " não suportado neste serviço.</p>")
                res.end()
            }
            break
        case "POST":
            if (req.url == '/alunos') {
                recuperaInfo(req, function (info) { // info =>
                    console.log('POST de aluno:' + JSON.stringify(info))
                    axios.post('http://localhost:3000/alunos', info)
                        .then(resp => {
                            res.writeHead(200, { 'Content-Type': 'text/html;charset=utf-8' })
                            res.write(geraPostConfirm(resp.data, d))
                            res.end()
                        })
                        .catch(function (erro) {
                            res.writeHead(200, { 'Content-Type': 'text/html;charset=utf-8' })
                            res.write('<p> Erro no POST:' + erro + '</p>')
                            res.write('<p> <a href="/"> Voltar</a></p>')
                            res.end()
                        })
                })
            }
            else {
                res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                res.write("<p> POST" + req.url + " não suportado neste serviço.</p>")
                res.end()
            }
            
            break
        default: 
            res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
            res.write("<p>" + req.method + " não suportado neste serviço.</p>")
            res.end()
    }}
})

galunoServer.listen(7777)
console.log('Servidor à escuta na porta 7777...')