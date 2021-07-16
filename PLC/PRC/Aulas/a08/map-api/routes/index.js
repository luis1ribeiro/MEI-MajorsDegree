var express = require("express");
var router = express.Router();
var axios = require("axios");
var gdb = require("../utils/graphdb");

router.get("/cidades", async function (req, res, next) {
	var myquery = `SELECT ?s ?nome ?distrito WHERE { ?s a :Cidade . ?s :nome ?nome . ?s :distrito ?distrito . } ORDER BY ?s`;
	var result = await gdb.execQuery(myquery);
	var dados = result.results.bindings.map((cidade) => {
		return {
			id: cidade.s.value.split("#")[1],
			nome: cidade.nome.value,
			distrito: cidade.distrito.value,
		};
	});
	res.jsonp(dados);
});

router.get("/cidades/:id", async function (req, res, next) {
	var myquery = `SELECT ?nome ?distrito ?populacao ?descricao WHERE {:${req.params.id} a :Cidade ; :nome ?nome ; :distrito ?distrito ; :populacao ?populacao ; :descricao ?descricao . } ORDER BY ?nome`;
	var result = await gdb.execQuery(myquery);
	myquery = `SELECT ?c ?n ?dist WHERE { ?s a :Ligacao ; :origem :${req.params.id}; :destino ?c; :distancia ?dist. ?c :nome ?n . } ORDER BY ?n`;
	var ligacoes = await gdb.execQuery(myquery);
	var lig = ligacoes.results.bindings.map((l) => {
		return {
			id: l.c.value.split("#")[1],
			nome: l.n.value,
			distancia: l.dist.value,
		};
	});
	var dados = result.results.bindings.map((cidade) => {
		return {
			id: req.params.id,
			nome: cidade.nome.value,
			distrito: cidade.distrito.value,
			populacao: cidade.populacao.value,
			descricao: cidade.descricao.value,
			ligacoes: lig,
		};
	});
	res.jsonp(dados[0]);
});

router.post("/cidades", async function (req, res, next) {
	var myquery = `INSERT DATA {
		:${req.body.id} rdf:type owl:NamedIndividual , :Cidade ;
		:descricao "${req.body.descricao}" ;
		:distrito "${req.body.distrito}" ;
		:nome "${req.body.nome}" ;
		:populacao ${req.body.populacao} .
	}`;

	var result = await gdb.execTransaction(myquery);
	res.jsonp("Triplos inseridos ... " + myquery);
});

router.delete("/cidades/:id", async function (req, res, next) {
	var cidade = await axios.get("http://localhost:13000/cidades/" + req.params.id);
	var myquery = ` DELETE DATA {
    	:${cidade.data.id} :descricao "${cidade.data.descricao}" ;
			:distrito "${cidade.data.distrito}" ;
			:nome "${cidade.data.nome}" ;
			:populacao ${cidade.data.populacao} .
	}`;
	var result = await gdb.execTransaction(myquery);
	res.jsonp("Triplos apagados ... " + result);
});

module.exports = router;
