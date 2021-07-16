var express = require('express')
var bodyParser = require('body-parser')
var templates = require('./html-templates')
/* Carregar e manipular a base de dados -> Operações IO sobre o ficheiro json */
var jsonfile = require('jsonfile')
var logger = require('morgan')
var fs = require('fs')

var multer = require('multer')
const { stringify } = require('querystring')
/* Onde vai guardar os ficheiros -> Instância do multer */
var upload = multer({dest: 'uploads/'})

var app = express()

/* Set Logger */
app.use(logger('dev'))

app.use(bodyParser.urlencoded({extended: false}))
app.use(bodyParser.json())

/* Tratar dos ficheiros estáticos que estão na pasta public/ */
app.use(express.static('public'))

app.get(['/files', '/'], function(req, res){
    var d = new Date().toISOString().substr(0, 16)
    /* Ler a base de dados */
    var files = jsonfile.readFileSync('./dbFiles.json')
    res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'})
    res.write(templates.fileList(files, d))
    res.write(templates.fileForm(d))
    res.end()
})

/*
app.get('/files/upload', function(req, res){
    var d = new Date().toISOString().substr(0, 16)
    res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'})
    res.write(templates.fileForm(d))
    res.end()
})*/

app.get('/download/:filename', function(req, res){
    res.download(__dirname + '/public/fileStore/' + req.params.filename)
})

/* Tratamento de vários ficheiros -> myFile */
/* Só quero dar upload do myFile quando dou post ao /files, não quero intercetar sempre no middleware */
app.post('/files', upload.array('myFile'), function(req, res){
    /* req.file is the 'myFile' file */
    /* req.body will hold the text fields if any */
    for (var i = 0; i < req.files.length; i++) {
        let quarantinePath = __dirname + '/' + req.files[i].path
        let newPath = __dirname + '/public/fileStore/' + req.files[i].originalname 

        console.log(req.files[i].originalname)

        /* dá move do ficheiro */
        fs.rename(quarantinePath, newPath, function(err){
            if(err){
                res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'})
                res.write('<p> ERROR: Erro ao mover o ficheiro da quarentena! </p>')
                res.end()
            }
        })

        var d = new Date().toISOString().substr(0, 16)
        var files = jsonfile.readFileSync('./dbFiles.json')

        files.push({
            date: d,
            name: req.files[i].originalname,
            mimetype: req.files[i].mimetype,
            size: req.files[i].size
        })

        jsonfile.writeFileSync('./dbFiles.json', files)
    }
    res.redirect('/')
})

/* () é uma função callback, após abrir a porta executa aquele console.log */
app.listen(7701, () => console.log('Servidor à escuta na porta 7701...'))