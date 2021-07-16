var express = require('express');
var axios = require('axios')
var router = express.Router();



router.get('/', function (req, res, next) {

  res.cookie('anterior', req.url, {
    expires: new Date(Date.now() + '1d'),
    secure: false,
    httpOnly: true
  })
  res.render('index');
});


router.get('/lista_classes', function (req, res, next) {

  axios.get('http://clav-api.di.uminho.pt/v2/classes?nivel=1&token=' + req.token)
    .then(dados => {

      res.cookie('anterior', req.url, {
        expires: new Date(Date.now() + '1d'),
        secure: false,
        httpOnly: true
      })
      res.render('lista_classes1', { lista: dados.data });
    })
    .catch(err => res.render('error', { error: err }))
});

router.get('/lista_termos', function (req, res, next) {

  axios.get('http://clav-api.di.uminho.pt/v2/termosIndice?token=' + req.token)
    .then(dados => {

      res.cookie('anterior', req.url, {
        expires: new Date(Date.now() + '1d'),
        secure: false,
        httpOnly: true
      })
      res.render('lista_termos', { lista_termos: dados.data });
    })
    .catch(err => res.render('error', { error: err }))
});

router.get('/nivel1/:id', function (req, res, next) {

  axios.get('http://clav-api.di.uminho.pt/v2/classes/' + req.params.id + '?token=' + req.token)
    .then(dados => {

      axios.get('http://clav-api.di.uminho.pt/v2/classes/' + req.params.id + '/descendencia?token=' + req.token)
        .then(dados_desc => {

          res.cookie('anterior', req.url, {
            expires: new Date(Date.now() + '1d'),
            secure: false,
            httpOnly: true
          })
          res.render('classe1', { n: dados.data, lista: dados_desc.data, anterior: req.cookies.anterior });

        })
        .catch(err => res.render('error', { error: err }))

    })
    .catch(err => res.render('error', { error: err }))
});

router.get('/nivel2/:id', function (req, res, next) {


  axios.get('http://clav-api.di.uminho.pt/v2/classes/' + req.params.id + '?token=' + req.token)
    .then(dados => {

      axios.get('http://clav-api.di.uminho.pt/v2/classes/' + req.params.id + '/descendencia?token=' + req.token)
        .then(dados_desc => {

          res.cookie('anterior', req.url, {
            expires: new Date(Date.now() + '1d'),
            secure: false,
            httpOnly: true
          })
          res.render('classe2', { n: dados.data, lista: dados_desc.data, anterior: req.cookies.anterior });

        })
        .catch(err => res.render('error', { error: err }))

    })
    .catch(err => res.render('error', { error: err }))
});




router.get('/nivel3/:id', function (req, res, next) {


  axios.get('http://clav-api.di.uminho.pt/v2/classes/' + req.params.id + '?token=' + req.token)
    .then(dados => {

      axios.get('http://clav-api.di.uminho.pt/v2/classes/' + req.params.id + '/procRel?token=' + req.token)
        .then(dados_rel => {

          res.cookie('anterior', req.url, {
            expires: new Date(Date.now() + '1d'),
            secure: false,
            httpOnly: true
          })
          dados.data.termosInd.map( a => {a.idTI=a.idTI.split('#')[1]})
          res.render('classe3_4', { n: dados.data, lista: dados_rel.data, anterior: req.cookies.anterior });

        })
        .catch(err => res.render('error', { error: err }))

    })
    .catch(err => res.render('error', { error: err }))
});





module.exports = router;
