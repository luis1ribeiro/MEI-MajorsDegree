var express = require('express');
var router = express.Router();
const Aluno = require('../controllers/aluno')

/* GET home page. */
router.get('/', function(req, res, next) {
  // render invoca o pug
  res.render('index', { title: 'Turma PRI de 2020' });
});


// Render vai à view buscar o pug
router.get('/alunos', (req, res) => {
  //res.render('alunos', {alunos: registos /* vem da base de dados */})
  Aluno.listar()
    .then(dados => res.render('alunos', {lista: dados}))
    .catch(e => res.render('error', {error: e}))
})

//só um aluno
router.get(/\/alunos\/:[0-9a-zA-Z]*/,(req,res)=>{
  var split = req.url.split(":")[1]
  console.log(split)
  Aluno.consultar(split)
    .then(aln => res.render('aluno',{aluno: aln}))
    .catch(e => res.render('error', {error: e}))

})

// Registar um aluno
router.get('/alunos/registar', (req, res) => {
  //res.render('alunos', {alunos: registos /* vem da base de dados */})
  res.render('form',{title: 'Registo de Aluno'})
})
// Post de aluno
router.post('/alunos', (req,res)=>{
  Aluno.inserir(req)
  res.redirect('/alunos')
})


// Editar um aluno
router.get(/\/alunos\/editar\/:[0-9a-zA-Z]*/, (req, res) => {
  //res.render('alunos', {alunos: registos /* vem da base de dados */})
  var split = req.url.split(":")[1]
  Aluno.consultar(split)
  .then(aln => res.render('editar',{aluno: aln}))
  .catch(e => res.render('error', {error: e}))
})
// Put de aluno
router.post('/alunos/edit', (req,res)=>{
  Aluno.editar(req)
  res.redirect('/alunos')
})


router.get(/\/alunos\/delete\/:[0-9a-zA-Z]*/, (req,res)=>{
  var split = req.url.split(":")[1]
  Aluno.remove(split)
  res.redirect('/alunos')
})


/* DELETE e PUT ROUTES
router.delete(/\/alunos\/:[0-9a-zA-Z]/, (req,res)=>{
  var split = req.url.split(":")[1]
  Aluno.remove(split)
  res.redirect('/alunos')
})

router.put(/\/alunos\/:[0-9a-zA-Z]/, (req,res)=>{
  var split = req.url.split(":")[1]
  Aluno.editar(split)
  res.redirect('/alunos')
}) */

module.exports = router;
