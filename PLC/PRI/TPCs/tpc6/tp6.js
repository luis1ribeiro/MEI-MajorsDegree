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

// Template para a página com a lista de alunos ------------------
function geraTarefas( lista){
  let pagHTML = `
            <div class="w3-container w3-teal">
                <h2>
                    toDoList - Tarefas
                </h2>
            </div>
            <table class="w3-table w3-bordered">
                <tr>
                    <th>ID</th>
                    <th>Descrição</th>
                    <th>Responsável</th>
                    <th>Data Limite</th>
                    <th>Arquivar/Cancelar</th>
                </tr>
  `
  /* ----------------------------------------------------
     To be replaced with code to generate the table rows
                            |
                            V
     ---------------------------------------------------- */
    lista.forEach(tarefa => {
        pagHTML += `
            <tr>
                <td>${tarefa.id}</td>
                <td><a href="/tarefas/${tarefa.id}"> ${tarefa.descr} </a></td>
                <td>${tarefa.resp}</td>
                <td>${tarefa.data_limite}</td>
                <td>
                <button class="w3-button" onclick="d(${tarefa.id})" type="submit" value="Feito">Feito</button>
                <button class="w3-button" onclick="c(${tarefa.id})" type="submit" value="Cancelado">Cancelado</button>
                </td>
            </tr>
        `
    });
  pagHTML += `
        </table>
  `
  return pagHTML
}

// Template para a página com a lista de alunos ------------------
function geraDone( d, c){
    let pagHTML = `
              <div class="w3-container w3-teal">
                  <h2>
                      Tarefas concluídas
                  </h2>
              </div>

              <table class="w3-table w3-bordered">
              <tr>
                    <th>Tarefa</th>
                    <th>Responsável</th>
                    <th>Estado</th>
                    <th></th>
                </tr>
    `
    /* ----------------------------------------------------
       To be replaced with code to generate the table rows
                              |
                              V
       ---------------------------------------------------- */
      d.forEach(tarefa => {
          pagHTML += `
              <tr>
                <td><a href="/tarefas/${tarefa.id}"> ${tarefa.descr}</a></td>
                <td>${tarefa.resp}</td>
                <td>Feito</td>
              </tr>
          `
      });
      c.forEach(tarefa => {
        pagHTML += `
            <tr>
                <td><a href="/tarefas/${tarefa.id}"> ${tarefa.descr}</a></td>
                <td>${tarefa.resp}</td>
                <td>Cancelado</td>
            </tr>
        `
      });
    pagHTML += `
          </table>
      </body>
      </html>
    `
    return pagHTML
  }

// Template para a página de tarefa -------------------------------------
function geraPagTarefa( tarefa){
    return `
    <html>
    <head>
        <title>Tarefa ${tarefa.id}</title>
        <meta charset="utf-8"/>
        <link rel="stylesheet" href="w3.css"/>
        <link rel="icon" href="favicon.png"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    </head>
    <body>
        <div class="w3-card-4">
            <header class="w3-container w3-teal">
                <h1>Tarefa ${tarefa.descr}</h1>
            </header>

            <div class="w3-container">
                <ul class="w3-ul w3-card-4" style="width:50%">
                    <li><b>Nome: </b> ${tarefa.descr}</li>
                    <li><b>Responsável: </b> ${tarefa.resp}</li>
                    <li><b>Data limite: </b> ${tarefa.data_limite}</li>
                    <li><b>Estado: </b> ${tarefa.estado}</li>
                </ul>
            </div>
        </div>
    </body></html>
    `
}

// Template para o formulário de aluno ------------------
function geraForm(){
    return `
    <html>
        <head>
            <title>Registo de uma Tarefa</title>
            <meta charset="utf-8"/>
            <link rel="stylesheet" href="w3.css"/>
            <link rel="icon" href="favicon.png"/>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
            <script src="https://code.jquery.com/jquery-3.4.1.min.js" ></script>
            <script type="text/javascript" src="funcoes.js" ></script>
        </head>
        <body>
        
            <div class="w3-container w3-teal">
                <h2>Registo de uma Tarefa</h2>
            </div>

            <form class="w3-container" action="/tarefas" method="POST"> 
                <label class="w3-text-teal"><b>Descrição</b></label>
                <input class="w3-input w3-border w3-light-grey" type="text" name="descr">
          
                <label class="w3-text-teal"><b>Responsável</b></label>
                <input class="w3-input w3-border w3-light-grey" type="text" name="resp">

                <label class="w3-text-teal"><b>Data Limite (AAAA/MM/DD)</b></label>
                <input class="w3-input w3-border w3-light-grey" type="text" name="data_limite">

                <input type="hidden" name="estado" value="toDo"/>
          
                <input class="w3-btn w3-blue-grey" type="submit" value="Registar"/>
                <input class="w3-btn w3-blue-grey" type="reset" value="Limpar valores"/> 
            </form>
    `
}


// Criação do servidor

var tarefaServer = http.createServer(function (req, res) {
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
            if((req.url == "/") || (req.url == "/tarefas") || (req.url == "/tarefas/")){
                var requestTarefas = axios.get("http://localhost:3000/tarefas?_sort=data_limite,resp&_order=asc,desc&estado=toDo")
                var requestDone = axios.get("http://localhost:3000/tarefas?estado=resolved")
                var requestCancelled = axios.get("http://localhost:3000/tarefas?estado=cancelled")
                axios.all([requestTarefas, requestDone, requestCancelled])
                    .then(axios.spread((...response) => {
                        var tarefas = response[0].data
                        var done = response[1].data
                        var cancelled = response[2].data
                        // Add code to render page with the student's list
                        res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                        // chama template em cima
                        res.write(geraForm())
                        res.write(geraTarefas(tarefas))
                        res.write(geraDone(done, cancelled))
                        res.end()
                    }))
                    .catch(function(erro){
                        res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                        res.write("<p>Não foi possível obter a lista de tarefas...")
                        res.end()
                    })
            }
            else if (/\/fechartarefa/.test(req.url)){
                var idt = req.url.split("=")[1]
                axios.get("http://localhost:3000/tarefas/" + idt)
                .then(response => {
                    requestget = response.data

                    axios.put("http://localhost:3000/tarefas/" + idt, {
                        descr: requestget.descr,
                        resp: requestget.resp,
                        data_limite: requestget.data_limite,
                        estado: 'resolved'
                    })
                    .then(response => {
                        console.log(response);
                    })
                    .catch(err => {
                        console.log(err);
                    });
                })
                .catch(err => {
                    console.log(err);
                });
                res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                res.end()
            }
            else if (/\/cancelartarefa/.test(req.url)){
                var idt = req.url.split("=")[1]
                axios.get("http://localhost:3000/tarefas/" + idt)
                .then(response => {
                    requestget = response.data

                    axios.put("http://localhost:3000/tarefas/" + idt, {
                        descr: requestget.descr,
                        resp: requestget.resp,
                        data_limite: requestget.data_limite,
                        estado: 'cancelled'
                    })
                    .then(response => {
                        console.log(response);
                    })
                    .catch(err => {
                        console.log(err);
                    });
                })
                .catch(err => {
                    console.log(err);
                });
                res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                res.end()
            }
            // GET /alunos/:id --------------------------------------------------------------------
            else if(/\/tarefas\/*/.test(req.url)){
                var idt = req.url.split("/")[2]
                console.log(idt)
                var tarefa = axios.get("http://localhost:3000/tarefas/" + idt)

                axios.all([tarefa])
                    .then(axios.spread((...response) => {

                        var t = response[0].data
                        console.log(t);

                        res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'});
                        res.write(geraPagTarefa(t));
                        res.end();
                    }))
                    .catch(function(erro){
                        res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                        res.write("<p>Não foi possível obter o registo de aluno...")
                        res.end()
                    })
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
                if (req.url == '/tarefas') {
                    recuperaInfo(req, resultado => {
                        console.log('POST de tarefas:' + JSON.stringify(resultado))
                        if (resultado.estado == 'toDo') {
                            axios.post('http://localhost:3000/tarefas', resultado)
                            .then(response => {
                                res.writeHead(200, { 'Content-Type': 'text/html;charset=utf-8' })
                                res.writeHead(302, { Location: "/" })
                                res.end()
                            })
                            .catch(function (erro) {
                                res.writeHead(200, { 'Content-Type': 'text/html;charset=utf-8' })
                                res.write("<p>Não foi possível adicionar a tarefa...")
                                res.end()
                            })
                        }
                    })
                }
                else {
                    res.writeHead(200, { 'Content-Type': 'text/html;charset=utf-8' })
                    res.write("<p> POST " + req.url + " não suportado neste serviço.</p>")
                    res.end()
                }
                break
        default: 
            res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
            res.write("<p>" + req.method + " não suportado neste serviço.</p>")
            res.end()
    }}
})

tarefaServer.listen(7777)
console.log('Servidor à escuta na porta 7777...')