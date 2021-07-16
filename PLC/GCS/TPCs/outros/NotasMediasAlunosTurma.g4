/*  FICHA 1 de Exercicios para as Aulas de GCS
        2. Notas Medias dos Alunos de uma Turma
            2.1 Definicao Sintatica
                Desenvolva uma GIC para definir uma linguagem que permita descrever os alunos (identificados pelo seu nome) de
                uma turma especifica.
            2.2 Defnicao Semantica
                Transforme a GIC numa GA de modo resolver os seguintes pedidos
                    a) contar o total de alunos
                    b) calcular a nota media de cada aluno
                    c) garantir que todos os alunos tem entre 4 e 6 notas e que estas estao na escala '0' a '20'
                    d) garantir que nao ha nomes repetidos
*/
grammar NotasMediasAlunosTurma;

turmas: turma+;



turma   /* returns [int totalAlunos] */
        /* @after { System.out.println("Total Alunos:" + $totalAlunos);}
            alunos { $totalAlunos = $alunos.totalAlunos; }
        */
        :
            TURMA
            ID
            alunos { System.out.println("Total Alunos:" + $alunos.totalAlunos); }
            PONTO
        ;


alunos returns [int totalAlunos]:
        a1=aluno      {$totalAlunos = 1; $a1.nomes.add($a1.name);}
        (
        PONTOVIRGULA a2=aluno {$totalAlunos +=1;
                               if($a1.nomes.contains($a2.name))
                               {
                                    System.out.println("Nome repetido! O nome " + $a2.name + " está repetido!");
                               }
                               else {$a1.nomes.add($a2.name);}}
        )*;


/* notas herdar nome : nome notas[$nome.text] e depois .. notas[String n] returns .. */
aluno returns [ArrayList<String> nomes, String name]: 
                   nome notas[$nome.text] {
                   $nomes = new ArrayList<String>();                        
                   $name = $nome.text;
                   float media = $notas.soma / $notas.totalNotas;
                   System.out.println("A média do/a " + $nome.text + " é " + media);
                   }
    ;


nome:   ID
    ;


notas[String nomeA] returns [int soma, int totalNotas]:
        LPAR
        n1=NUM                      {   $soma = $n1.int;
                                        $totalNotas = 1;
                                        if(!($n1.int >= 0 && $n1.int =< 20)) System.out.println("ERRO -> Nota fora da escala '0' a '20'.");
                                    }
        (
        VIRGULA n2=NUM              {   $soma += $n2.int;
                                        $totalNotas += 1;
                                        if(!($n2.int >= 0 && $n2.int =< 20)) System.out.println("ERRO -> Nota fora da escala '0' a '20'.");
                                    }
        )*
        RPAR                        {   if ($totalNotas < 4) System.out.println("ERRO -> O Aluno " + $nomeA + " tem menos do que 4 notas");
                                        if ($totalNotas > 6) System.out.println("ERRO -> O Aluno " + $nomeA + " tem mais do que 6 notas");
                                    }

      ;



//LEXER
TURMA: [tT][uU][rR][mM][aA];
ID: [a-zA-Z]+;
NUM: [0-9]+;
VIRGULA: ',';
PONTOVIRGULA: ';';
PONTO: '.';
LPAR: '(';
RPAR: ')';
WS:('\r'?'\n'|'\t'|' ') -> skip;