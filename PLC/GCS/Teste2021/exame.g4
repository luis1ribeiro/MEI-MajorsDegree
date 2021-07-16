grammar exame;

arqFam: nomeFam docs '.' fotos '.' 
        {
         System.out.println("Quantidade de documentos = " + $docs.num);
         System.out.println("Quantidade de fotos = " + $fotos.numF);
         System.out.println("A Lista de documentos que contém testamentos é esta: " + $docs.testamentos);
        }
    ;

nomeFam:  'ARQUIVO DOS' PAL ':'
    ;

docs returns [int num, ArrayList<String> testamentos]
@init {$num = 0; $testamentos = new ArrayList<String>();} 
    : (doc[$docs.testamentos] {$num += 1; $docs.testamentos = $doc.testamentosOut} ';')*
    ;

doc[ArrayList<String> testamentosIn]
    returns [ArrayList<String> testamentosOut]
    @init { $testamentosOut = $testamentosIn}
    : ref tipo desc filename
                              {
                              if ($tipo.bool == 1) {
                                  $doc.testamentosOut.add($filename.text);                    
                             }}
   ;

fotos returns [int numF]
    @init {$numF = 0; }
    : foto {$numF += 1;} 
      (';' foto {$numF += 1;})*
;

foto: 'FOTO' PAL '.' ano ',' filename;

tipo
    returns[int bool]
     @init { $bool = 0;} : ('CERTIDAO'|'TESTAMENTO' {$bool=1;}) ;

filename: PAL;
ano: NUM;
ref: ID titulo;
titulo: 'TIT' '=' PAL;
desc: PAL;

/* LEXER */
ID: [ID][0-9]{5} 
  ;
NUM: [0-9]{4} //ou ('0'..'9')+
   ;
PAL: [a-zA-Z][a-zA-Z0-9]+
       ;
WS: ('\r'? '\n' | ' ' | '\t')+ -> skip;
