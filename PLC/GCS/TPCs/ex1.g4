/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar ex1;

@members{
         int totalnmrs = 0;
         int tam = 0;
         int soma = 0;
         int totalPalavras = 0;
         int start = 0; int stop = 0;
}
lista: listas+
     ;
listas: Lista args '.' {/*System.out.println("Tamanho da lista: ..." + tam);
                        System.out.println("Ocorr de nmrs: ..." + totalnmrs);
                        System.out.println("Tamanho da lista: ..." + tam);
                        if (totalnmrs == totalPalavras) System.out.println("Igual nmr de palavras e nmrs");
                        else System.out.println("Erro"); */
                        System.out.println("Soma dos n�meros = " + soma);
                        tam = 0; start = stop = 0;
                        totalnmrs = 0; totalPalavras = 0;
                        soma = 0;}
     ;
/*
args: arg ',' args
    | arg
    ;
*/
args returns [int total]
@init {total = 0}
    : a1=arg    {$total = $a1.number;}
    (',' a2=arg)* {$total += $a2.number;}
    ;

/* ou
args: arg {tam=1;} (',' arg {tam++;})*
*/
arg returns [int number]
   : NUM    {tam++; totalnmrs++; if (start == 1 && stop == 0) soma+= $NUM.int; $number = $NUM.int;}
   | PAL    {tam++; totalPalavras++; if ($PAL.text.equals("start")) start = 1; if ($PAL.text.equals("stop")) stop = 1; $number = 0;}
   ;

//LEXER
Lista: [lL][iI][sS][tT][aA]
     ;
NUM: [0-9]+ //ou ('0'..'9')+
   ;
PAL: [a-zA-Z][a-zA-Z0-9]+
       ;
WS: ('\r'? '\n' | ' ' | '\t')+ -> skip;
