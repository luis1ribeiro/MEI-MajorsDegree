%{
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
%}
%option noyywrap  yylineno
%x UCS DOC ALUNOS OBJU OBJD OBJA

Abrev ER

%%
\{                    {printf("\n################## UCS ##################\n");}
\"ucs\"\:[ ]\[	      {BEGIN UCS;}
\"docentes\"\:[ ]\[		{BEGIN DOC;}
\"alunos\"\:[ ]\[		  {BEGIN ALUNOS;}
<UCS>{
  \{              {BEGIN OBJU;}
  <OBJU>{
    \"id\"\:[ ]\"[^\"]*/\"\,             {
                                            printf("### http://www.semanticweb.org/xalug/ontologies/uc#%s\n", yytext+7);
                                            printf("            :%s rdf:type owl:NameIndividual , :UC ;",yytext+7);
                                         }
    \"designacao\"\:[ ]\"[^\"]*\"/\,     {printf(":designacao %s ;",yytext+14);}
    \"anoLetivo\"\:[ ]\"[^\"]*\"         {printf(":anoletivo %s .",yytext+13);}
    \}                                   {BEGIN UCS;}
    \,|\"|\t|\r                             ;
  }
  \]              {BEGIN 0;printf("\n################## DOCENTES ##################\n");}
}
<DOC>{
  \{              {BEGIN OBJD;}
  <OBJD>{
    \"id\"\:[ ]\"[^\"]*/\"\,              {
                                            printf("### http://www.semanticweb.org/xalug/ontologies/uc#%s", yytext+7);
                                            printf("\n");
                                            printf("            :%s rdf:type owl:NameIndividual , :Professor ;",yytext+7);
                                          }
    \"nome\"\:[ ]\"[^\"]*\"/\,            {printf(":nome %s ;",yytext+8);}
    \"ensina\"\:[ ]\"[^\"]*/\"            {
                                            printf(":ensina ");
                                            char* ucs_profs[4];
                                            for(int j=0; j<4;j++) {
                                              ucs_profs[j] = NULL;
                                            }
                                            int i=0;
                                            char* token = strtok(yytext+11, ",");
                                            while(token)
                                            {
                                              ucs_profs[i] = token;
                                              token = strtok(NULL, ",");
                                              i++;
                                            }
                                            if(ucs_profs[0]){
                                              printf(":%s ", ucs_profs[0]);
                                            }
                                            if(ucs_profs[1]){
                                              printf(", ");
                                              printf(":%s ", ucs_profs[1]);
                                            }
                                            if(ucs_profs[2]){
                                              printf(", ");
                                              printf(":%s ", ucs_profs[2]);
                                            }
                                            if(ucs_profs[3]){
                                              printf(", ");
                                              printf(":%s ", ucs_profs[3]);
                                            }
                                            printf(".");
                                          }
    \}                                    {BEGIN DOC;}
    \,|\"|\t|\r                              ;
  }
  \]              {BEGIN 0;printf("\n################## ALUNOS ##################\n");}
}
<ALUNOS>{
  \{              {BEGIN OBJA;}
  <OBJA>{
    \"id\"\:[ ]\"[^\"]*/\"\,              {
                                            printf("### http://www.semanticweb.org/xalug/ontologies/uc#%s", yytext+7);
                                            printf("\n");
                                            printf("            :%s rdf:type owl:NameIndividual , :Aluno ;",yytext+7);
                                          }
    \"nome\"\:[ ]\"[^\"]*\"/\,            {printf(":nome %s ;",yytext+8);}
    \"estuda\"\:[ ]\"[^\"]*/\"            {
                                            printf(":frequenta ");
                                            char* ucs_alunos[4];
                                            int i=0;
                                            char* tokenA = strtok(yytext+11, ",");
                                            while(tokenA)
                                            {
                                              ucs_alunos[i] = tokenA;
                                              tokenA = strtok(NULL, ",");
                                              i++;
                                            }
                                            if(ucs_alunos[0]){
                                              printf(":%s ", ucs_alunos[0]);
                                            }
                                            if(ucs_alunos[1]){
                                              printf(", ");
                                              printf(":%s ", ucs_alunos[1]);
                                            }
                                            if(ucs_alunos[2]){
                                              printf(", ");
                                              printf(":%s ", ucs_alunos[2]);
                                            }
                                            if(ucs_alunos[3]){
                                              printf(", ");
                                              printf(":%s ", ucs_alunos[3]);
                                            }
                                            printf(".");
                                          }
    \}                                    {BEGIN ALUNOS;}
    \,|\"|\t|\r                              ;
  }
  \]              {BEGIN 0;}
}

.|\n			{;}

%%
int main()
{
  yylex();
  return 0;
}
