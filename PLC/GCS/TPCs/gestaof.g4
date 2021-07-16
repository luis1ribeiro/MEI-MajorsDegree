/*  4. Gestao de Stock e Faturacao
        4.1 Definicao Sintatica
            Considere uma linguagem especifica para descrever Faturas.
            Sabe-se que uma Fatura e composta por um cabecalho e um corpo, e este e composto por um ou mais movimentos.
            No cabecalho deve aparecer o numero da Fatura, a Identificao do Fornecedor (nome, NIF, morada e NIB) e a
            Identificao do Cliente (nome, NIF, morada). Em cada linha do corpo da Fatura pretende-se, apenas incluir a
            Referencia ao produto vendido e a Quantidade vendida.
            Para ser possivel processar as faturas convenientemente e necessario que no inicio de cada frase dessa linguagem surja
            uma descricao do Stock, conjunto de produtos, sendo cada produto definido por: referencia do produto, descricao,
            preco unitario e quantidade em stock.
            Escreva entao uma Gramatica Independente de Contexto, GIC, que especifique a Linguagem pretendida.

        4.2 Definicao Semantica
            Escreva uma Gramatica de Atributos, GA, para calcular o total por linha e total geral, caso nao sejam detetados erros
            semanticos (referencias a produtos que nao existem em Stock, ou venda de quantidades superiores as existentes). Note
            que o seu processador deve atualizar o Stock de acordo com as vendas registadas em cada linha da fatura.
*/

grammar gestaof;

@header {
    import java.util.*;
}

@members {
    class Produto{
        String descr;
        Double prec;
        int qtd;
           
        public String toString(){
            StringBuffer sb = new StringBuffer();
            sb.append(this.descr + "; ");
            sb.append(this.prec + "; ");
            sb.append(this.qtd + ". ");
            return sb.toString();
        }
    }
}

gestao: stock ';' ';' faturas[$stock.prodts];

stock
	returns[HashMap<String, Produto> prodts]
	@init {$stock.prodts = new HashMap<String, Produto>(); }:
	'STOCK' p1 = produto[$stock.prodts] { $stock.prodts=$p1.prodout; } 
    ( ';' p2 = produto[$stock.prodts] { $stock.prodts=$p2.prodout; } )* 
    { System.out.println("Quantidades em Stock no inicio:"); System.out.println($stock.prodts.toString()); };

produto[HashMap<String, Produto> prodin]
	returns[HashMap<String, Produto> prodout]
        @init {$produto.prodout = new HashMap<String, Produto>(); }:
	refProd ':' descProd ',' valUnit ',' quantS     {   
                                                        Produto p = new Produto(); 
                                                        p.descr=$descProd.text;
                                                        p.prec=Double.parseDouble($valUnit.text);
                                                        p.qtd=Integer.parseInt($quantS.text);
                                                        $produto.prodin.put($refProd.text, p);
                                                        $produto.prodout=$produto.prodin;
                                                    };

faturas[HashMap<String, Produto> prodts]:
    {
    System.out.println("Quantidades em Stock no meio:"); System.out.println($faturas.prodts.toString());
    }
	f1 = fatura[$faturas.prodts]
    ( ';' f2 = fatura[$faturas.prodts])* 
    { System.out.println("Quantidades em Stock no fim:"); 
      System.out.println($faturas.prodts.toString()); 
    };

fatura[HashMap<String, Produto> prodin]:
	'FATURA' cabecalho 'VENDAS' corpo[$fatura.prodin] PONTO     {System.out.println("TOTAL da Fatura: "+ $corpo.totF);};

cabecalho: numFat ':' fornecedor '/' cliente                        { System.out.println("FATURA num: " + $numFat.text);};

numFat: ID;

fornecedor: nome ':' morada ',' nif ',' nib;

cliente: nome ':' morada ',' nif;

nome: STR;

nif: STR;

morada: STR;

nib: STR;

corpo[HashMap<String, Produto> prodin] returns [Double totF]:
	 HIFEN l1=linha[$corpo.prodin] { $corpo.totF = $l1.totL; } 
    ( HIFEN l2=linha[$corpo.prodin] { $corpo.totF += $l2.totL;} )*;

linha[HashMap<String, Produto> prodin] returns [Double totL]:
	refProd '|' quant       {   Produto p;
                                if ($linha.prodin.containsKey($refProd.text)) {
                                    p = $linha.prodin.get($refProd.text);
                                    if(Integer.parseInt($quant.text) <= p.qtd) {
                                        System.out.println($refProd.text +"-> "+ (p.prec * (Integer.parseInt($quant.text))));
                                        $linha.totL = (p.prec * (Integer.parseInt($quant.text)));
                                        p.qtd -= Integer.parseInt($quant.text);
                                        $linha.prodin.put($refProd.text,p);
                                    }
                                    else {System.out.println("ERRO: A quantia de venda do produto " + $refProd.text + " excede a quantidade em stock");
                                           $linha.totL = 0.0;}    
                                }
                                else  { 
                                    System.out.println("ERRO: A Referencia " + $refProd.text + " nao existe em Stock");
                                    $linha.totL = 0.0; 
                                } 
                            };
refProd: ID;

valUnit: NUM;

quant: NUM;

descProd: STR;

quantS: NUM;

/*--------------- LEXER ---------------------------------------*/
ID: ('a' ..'z' | 'A' ..'Z' | '_') ('a' ..'z' | 'A' ..'Z' | '0' ..'9' | '_' | '-' )*;

NUM: '0' ..'9'+ ('.' ('0' ..'9')+)?;

HIFEN:'-';

PONTO:'.';

WS: [ \t\r\n] -> skip;

STR: '"' ( ~('"'))* '"';
