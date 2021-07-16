var express = require('express')
/* Se receber um pedido GET -> Hello World */
/* Se for outro pedido, esta função interceta o pedido e imprime o body para a consola */
var bodyParser = require('body-parser')
var app = express()

/* Função de middleware (funciona como um PIPELINE) -> Dados URL enconded */
app.use(bodyParser.urlencoded({extended: false}))
/* Dados em JSON */
app.use(bodyParser.json())

/* MIDDLEWARE */
app.use(function(req, res, next){
    console.log(JSON.stringify(req.body))
    next()
})

/* Intercetar o GET */
app.get('*', function(req, res) {
    res.status(200).send('Hello World')
}) 

/* Intercetar qualquer pedido POST -> Envia a informação de volta em JSON */
app.post('*', function(req,res) {
    res.status(201).json(JSON.stringify(req.body))
})

/* () é uma função callback, após abrir a porta executa aquele console.log */
app.listen(7700, () => console.log('Servidor à escuta na porta 7700...'))