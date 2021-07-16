var express = require('express');
var router = express.Router();
var axios = require('axios')

if(typeof localStorage === "undefined" || localStorage === null){
  var LocalStorage = require('node-localstorage').LocalStorage;
  localStorage = new LocalStorage('./localState');
}

/* GET home page. */

router.get('/', function(req, res) {
//  res.render('login-form');
//});
//router.post('/login', function(req, res) {
  axios.post("http://clav-api.di.uminho.pt/v2/users/login",  { username: 'pri2020@teste.uminho.pt', password: '123' })
    .then(dados => {
      localStorage.setItem('myToken.txt', dados.data.token)
      res.redirect('/classes')
    })
    .catch(e => res.render('error', {error: e}))
});

router.get('/classes', function(req, res, next) {
  var t = localStorage.getItem('myToken.txt')
  axios.get('http://clav-api.di.uminho.pt/v2/classes?nivel=1&token=' + t)
    .then(dados => res.render('classes', {classes: dados.data}))
    .catch(e => res.render('error', {error: e}))
});

router.get('/classe/:id', function(req, res, next) {
  var t = localStorage.getItem('myToken.txt')
  var classe = req.params.id
  axios.get('http://clav-api.di.uminho.pt/v2/classes/c'+ classe + '?token='+ t)
    .then(c => {
      axios.get('http://clav-api.di.uminho.pt/v2/classes/c'+ classe + '/descendencia?token=' + t)
        .then(d =>{ 
          axios.get('http://clav-api.di.uminho.pt/v2/classes/c'+ classe + '/procRel?token=' + t)
            .then(p => res.render('classe', {classe: c.data, desc: d.data, proc: p.data, ant: req.query.classe, antant: req.query.ant}))
            .catch(e => res.render('error', {error: e}))
    })
        .catch(e => res.render('error', {errorr: e}))
    })
    .catch(e => res.render('error', {error: e}))
});

router.get('/processo/:id', function(req, res, next) {
  var t = localStorage.getItem('myToken.txt')
  axios.get('http://clav-api.di.uminho.pt/v2/classes/c'+ req.params.id + '/procRel?token=' + t)
    .then(p => {console.log(p.data)
      res.render('processo', {proc: p.data, classe: req.query.classe})
    })
    .catch(e => res.render('error', {error: e}))
});



router.get('/curso/:id', function(req, res, next) {
  axios.get('http://localhost:3000/cursos/' + req.params.id)
    .then(dados => res.render('curso', {curso: dados.data, aluno: req.query.aluno}))
    .catch(e => res.render('error', {error: e}))
});

module.exports = router;
