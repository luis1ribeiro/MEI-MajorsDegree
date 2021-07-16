var http = require('http')
var axios = require('axios')

var servidor = http.createServer(function(req,res){

    console.log(req.method + ' - ' + req.url)
    if(req.method == 'GET'){
        if(req.url == '/'){
            res.writeHead(200,{'Content-Type': 'text/html; charset=utf-8'})
            res.write('<h2>Escola de Música</h2>')
            res.write('<ul>')
            res.write('<li><a href="/alunos">Lista de alunos</a></li>')
            res.write('<li><a href="/cursos">Lista de cursos</a></li>')
            res.write('<li><a href="/instrumentos">Lista de instrumentos</a></li>')
            res.write('</ul>')
            res.end()
        }
        else if(req.url == '/alunos'){
            axios.get('http://localhost:3000/alunos?_sort=nome&_order=asc')
            .then(function (resp){
                alunos = resp.data
                res.writeHead(200,{'Content-Type': 'text/html; charset=utf-8'})
                res.write('<h2>Escola de Música: Lista de alunos</h2>')
                res.write('<ul>')
                alunos.forEach(a => {
                    res.write(`<li><a href=alunos/${a.id}> ${a.id} </a> - ${a.nome}</li>`)
                    //res.write(`<dd>${a.nome}</dd>`)
                })
                res.write('</ul>')
                res.write('<address>[<a href="/">Voltar</a>]</address>')
                res.end()
            })
            .catch(function(error){
                console.log("Erro na obtenção da lista de alunos " + error)
            })
        }else if (req.url.match(/\/alunos\/[A]([E][\-])?[0-9]{2,5}/)){
            var split = req.url.split("/")[2]
            axios.get('http://localhost:3000/alunos/'+ split)
                .then(function (resp){
                    aluno = resp.data
                    res.writeHead(200,{'Content-Type': 'text/html; charset=utf-8'})
                    res.write(`<h3>Ficha Aluno: ${aluno.nome} </h3>`)
                    res.write('<ul>')
                    res.write(`<li> ID: ${aluno.id} </li>`)
                    res.write(`<li> Nome: ${aluno.nome} </li>`)
                    res.write(`<li> Data de Nascimento: ${aluno.dataNasc} </li>`)
                    res.write(`<li> Curso: ${aluno.curso} </li>`)
                    res.write(`<li> Instrumento: ${aluno.instrumento} </li>`)
                    res.write(`<li> Ano do Curso: ${aluno.anoCurso} </li>`)
                    res.write('</ul>')
                    res.write('<address>[<a href="/alunos">Voltar</a>]</address>')
                    res.end()
                })
                .catch(function(error){
                    console.log("Erro na obtenção do aluno " + error) })
        }
        else if(req.url == '/cursos'){
            axios.get('http://localhost:3000/cursos?_sort=id&_order=asc')
            .then(function (resp){
                cursos = resp.data
                res.writeHead(200,{'Content-Type': 'text/html; charset=utf-8'})
                res.write('<h2>Escola de Música: Lista de Cursos</h2>')
                res.write('<ul>')
                cursos.forEach(c => {
                    res.write(`<li><a href=cursos/${c.id}> ${c.id} </a> - ${c.designacao}</li>`)
                })
                res.write('</ul>')
                res.write('<address>[<a href="/">Voltar</a>]</address>')
                res.end()
            })
            .catch(function(error){
                console.log("Erro na obtenção da lista de cursos " + error)
            })
        }else if (req.url.match(/cursos\/C[B|S][0-9]+/)){
                var reg_curso = req.url.split("/")[2]
                axios.get('http://localhost:3000/cursos/'+ reg_curso)
                    .then(function (resp){
                        curso = resp.data
                        res.writeHead(200,{'Content-Type': 'text/html; charset=utf-8'})
                        res.write(`<h3>Escola de Música: ${curso.designacao} </h3>`)
                        res.write('<ul>')
                        res.write(`<li> ID: ${curso.id} </li>`)
                        res.write(`<li> Designação: ${curso.designacao} </li>`)
                        res.write(`<li> Duração: ${curso.duracao} </li>`)
                        res.write(`<li> ID Instrumento: ${curso.instrumento.id} </li>`)
                        res.write(`<li> Nome Instrumento: ${curso.instrumento["#text"]} </li>`)
                        res.write('<address>[<a href="/cursos">Voltar</a>]</address>')
                        res.end()
                    })
                    .catch(function(error){
                        console.log("Erro na obtenção do Curso " + curso.designacao + ", Erro" + error) })

        }
        else if(req.url == '/instrumentos'){
            axios.get('http://localhost:3000/instrumentos')
            .then(function (resp){
                instrumentos = resp.data
                res.writeHead(200,{'Content-Type': 'text/html; charset=utf-8'})
                res.write('<h2>Escola de Música: Lista de instrumentos</h2>')
                res.write('<ul>')
                instrumentos.forEach(i => {
                    res.write(`<li><a href=instrumentos/${i.id}> ${i.id}</a> - ${i["#text"]}</li>`)
                })
                res.write('</ul>')
                res.write('<address>[<a href="/">Voltar</a>]</address>')
                res.end()
            })
            .catch(function(error){
                console.log("Erro na obtenção da lista de instrumentos " + error)
            })

        }else if (req.url.match(/instrumentos\/I[0-9]+/)){
            var split = req.url.split("/")[2]
            var ins_id =/[0-9]+/.exec(split)
            axios.get('http://localhost:3000/instrumentos/I'+ ins_id )
                .then(function (resp){
                    instrumento = resp.data
                    res.writeHead(200,{'Content-Type': 'text/html; charset=utf-8'})
                    res.write(`<h3>Escola de Música: ${instrumento["#text"]}</h3>`)
                    res.write('<ul>')
                    res.write(`<li>ID Instrumento:  ${instrumento.id}</li>`)
                    res.write(`<li>Nome Instrumento:  ${instrumento["#text"]}</li>`)
                    res.write('</ul>')
                    res.write('<address>[<a href="/instrumentos">Voltar</a>]</address>')
                    res.end()
                })
                .catch(function(error){
                    console.log("Erro na obtenção do Curso " + instrumento.id + ", Erro" + error) })
                }else{
            res.writeHead(200,{'Content-Type': 'text/html; charset=utf-8'})
            res.write("<p>Pedido não suportado: " + req.method + " - " + req.url + "</p>")
            res.end()
        }
    }
    else{
        res.writeHead(200,{'Content-Type': 'text/html; charset=utf-8'})
        res.write("<p>Pedido não suportado: " + req.method + " - " + req.url + "</p>")
        res.end()
    }

})

servidor.listen(3001)
console.log('Servidor à escuta na porta 3001...')
