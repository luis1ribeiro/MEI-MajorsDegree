#include<stdio.h>
#include<stdlib.h>

int main(int argc, char* argv[]) {

  int M[4][4];

  /* Primeiro ciclo i=1 */
  int i=1;int j=1; /* Declarações iniciais */
  M[i][j] = i+j;
  j=j+1;
  M[i][j] = i+j;
  j=j+1;
  M[i][j] = i+j;

  /* Segundo ciclo i=2 */
  i=i+1;j=1;
  M[i][j] = i+j;
  j=j+1;
  M[i][j] = i+j;
  j=j+1;
  M[i][j] = i+j;

  /* Terceiro ciclo i=3 */
  i=i+1;j=1;
  M[i][j] = i+j;
  j=j+1;
  M[i][j] = i+j;
  j=j+1;
  M[i][j] = i+j;

	return 0;
}

