/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar Ex12;

@members {
    int tamanho = 0;
    int totalNumeros = 0;
    int somaNumeros = 0;
    int totalPalavras = 0;
    int agora = 0;
    int max = -1;
}

listas: lista+
      ;

lista: Lista elementos '.'              { System.out.println("Tamanho da lista: " + tamanho);  
                                          System.out.println("Ocorre de numeros: " + totalNumeros);
                                          System.out.println("Soma de numeros: " + somaNumeros);
                                          System.out.println("O maior número da lista: " + max);
                                          if(totalNumeros == totalPalavras) System.out.println("Igual número de palavras e números.");
                                          else System.out.println("Erro: Diferente n�mero de palavras e nrs.  totalNumeros: " + totalNumeros + ", totalPalavras: " + totalPalavras);
                                          totalNumeros = 0; totalPalavras = 0;
                                          somaNumeros = 0;
                                          agora = 0;
                                          max = -1;
                                        }
     ;

elementos: elemento {tamanho=1; } (',' elemento {tamanho++;} )*
         ;
           
elemento: PALAVRA                       {if($PALAVRA.text.equals("Agora")) agora++; agora = agora%2;
                                         totalPalavras++;}
        | NUM                           {totalNumeros++;   if(agora==1) somaNumeros += $NUM.int; if (max < $NUM.int) max=$NUM.int}
        ;

//Lexer
Lista: [lL][iI][sS][tT][aA]
     ;

NUM: ('0'..'9')+ //[0-9]+
   ;

PALAVRA: [a-zA-Z][a-zA-Z0-9]*
       ;

WS: ('\r'? '\n' | ' ' | '\t')+ -> skip;