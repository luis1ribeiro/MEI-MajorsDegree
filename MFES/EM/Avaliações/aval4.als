abstract sig Status {}
one sig Unissued, Issued, Cancelled extends Status {}

sig Card {
	var status : one Status
}

sig Client {
	var cards : set Card
}

pred prop1 {
	  // Os clientes nunca podem ter cartões não emitidos
  	always no Unissued & Client.cards.status
  	//always no Client.cards.status<:Unissued
}


pred prop2 {
	  // Todos os cartões emitidos vão inevitavelmente ser cancelados
  	always all c : Card | c.status = Issued implies eventually c.status = Cancelled
  	//always all c: status.(Status<:Issued) | eventually c.status =(ou in) Cancelled
}


pred prop3 {
	  // Um cartão nunca pode pertencer a dois clientes diferentes
  	always all c : Card, cli : Client | c in cli.cards implies always c not in (Client - cli).cards
  	//always (all cli: Client, c: cli.cards | always no (Client - cli) & cards.c)
}
