var express = require('express');
var router = express.Router();

const Batismo = require('../controllers/batismo')


// GET /api/batismos - Devolve a lista dos batismos, 
//com os campos: _id, date, title e ref;

router.get('/batismos', function (req, res) {

  if (req.query.ano) {
    //GET /api/batismos?ano=YYYY - Devolve a lista de batismos realizados no ano YYYY;
    Batismo.listar5(req.query.ano)
      .then(dados => res.status(200).jsonp(dados))
      .catch(e => res.status(500).jsonp({ error: e }))
  }
  else {
    Batismo.listar1()
      .then(dados => res.status(200).jsonp(dados))
      .catch(e => res.status(500).jsonp({ error: e }))
  }
});

//GET /api/batismos/batisado - Devolve apenas uma lista com os 
//nomes dos indivíduos batizados ordenada alfabeticamente;
router.get('/batismos/batisado', function (req, res) {
  console.log("hduahs")
  Batismo.listar3()
    .then(dados => res.status(200).jsonp(dados.map(a => a.nome)))
    .catch(e => res.status(500).jsonp({ error: e }))
});

// GET /api/batismos/progenitores - Devolve uma lista de triplos em que cada 

//triplo tem a seguinte estrutura: 
//{_id: "identificador do registo original", 
//pai: "nome do pai do indivíduo que foi batizado",
// mae: "nome da mae do indivíduo que foi batizado"};
// Esta alínea poderá ser resolvida de várias maneira e
// irá depender da forma como resolveste as primeiras.
router.get('/batismos/progenitores', function (req, res) {

  Batismo.listar4()
    .then(dados => res.status(200).jsonp(dados))
    .catch(e => res.status(500).jsonp({ error: e }))
});

//GET /api/batismos/stats - Devolve uma lista de pares, ano 
//e número de batismos nesse ano
router.get('/batismos/stats', function (req, res) {

  Batismo.stats6()
    .then(dados => res.status(200).jsonp(dados))
    .catch(e => res.status(500).jsonp({ error: e }))
});

// GET /api/batismos/:id - Devolve a informação completa de um batismo;
router.get('/batismos/:id', function (req, res) {
  Batismo.consultar2(req.params.id)
    .then(dados => res.status(200).jsonp(dados))
    .catch(e => res.status(500).jsonp({ error: e }))
});



module.exports = router;
