var express = require('express');
var router = express.Router();

var ParaControl = require('../controllers/para')

/* GET home page. */
router.get('/paras', function(req, res, next) {
  ParaControl.list()
    .then(data => res.status(200).jsonp(data))
    .catch(err => res.status(500).jsonp(err));
});

/* POST de Parágrafos */
router.post('/paras', (req,res)=>{
  ParaControl.insert(req.body)
    .then(data => res.status(201).jsonp(data))
    .catch(err => res.status(500).jsonp(err));
})

/* DELETE de Parágrafos */
router.delete('/paras/:id', (req,res)=>{
  ParaControl.remove(req.params.id)
    .then(data => res.status(200).jsonp(data))
    .catch(err => res.status(500).jsonp(err));
})

/* EDIT de Parágrafos */
router.put('/paras/:id', (req,res)=>{
  ParaControl.edit(req.params.id, req.body)
    .then(data => res.status(200).jsonp(data))
    .catch(err => res.status(500).jsonp(err));
})

module.exports = router;
