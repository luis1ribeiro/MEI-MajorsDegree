sig Artigo {
	oferta : Pessoa -> Valor
}
sig Valor {}
sig Pessoa {
	leiloes : set Artigo
}

pred inv1 {
	// O mesmo artigo não pode ser leiloado por duas pessoas diferentes
  leiloes.~leiloes in iden
}


pred inv2 {
	// Uma pessoa não pode fazer ofertas em artigos que está a leiloar
	all p : Pessoa | p not in (p.leiloes.oferta).Valor
	// ou
	all p : Pessoa | no p.leiloes & oferta.Valor.p
	// ou
	no leiloes.oferta.Valor & iden
	// ou
	no ~leiloes & oferta.Valor
}


pred inv3 {
	// Não pode haver duas ofertas de igual valor para o mesmo artigo
	all a : Artigo | (a.oferta).~(a.oferta) in iden
}

