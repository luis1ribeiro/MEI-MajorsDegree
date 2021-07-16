/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar teste;

lista: listas+
     ;
listas: LPARA args RPARA '.' 
                        {
                        System.out.println("Quantidade de números pares da lista = " + $args.total_pares);
                        System.out.println("A Lista inversa das palavras é a seguinte: " + $args.palavras_inversas);
                        }
     ;

args returns [int total_pares, ListStr palavras_inversas]
@init {total_pares = 0; $palavras_inversas = new ListStr;}
    : a1=arg[$args.palavras_inversas]     {$args.palavras_inversas = $arg.list_out; if($a1.number > 0 && ($a1.number mod 2)==0){$total_pares += 1;}}
    (',' a2=arg[$args.palavras_inversas])* {$args.palavras_inversas = $arg.list_out; if($a1.number > 0 && ($a2.number mod 2)==0){$total_pares += 1;}}
    ;


arg[ListStr list_in] returns [int number, ListStr list_out]
@init{$list_out = new ListStr;}
   : NUM    {$arg.list_out = $arg.list_in; $number = $NUM.int;}
   | PAL    {$arg.list_out = $arg.list_in; $number = 0; $arg.list_out.cons($PAL.text);}
   ;

//LEXER
LPARA: [\[];
RPARA: [\]];
NUM: [0-9]+ //ou ('0'..'9')+
   ;
PAL: [a-zA-Z][a-zA-Z0-9]+
       ;
WS: ('\r'? '\n' | ' ' | '\t')+ -> skip;
