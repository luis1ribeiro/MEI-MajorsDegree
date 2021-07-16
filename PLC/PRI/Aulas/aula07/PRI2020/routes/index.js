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

module.exports = router;
