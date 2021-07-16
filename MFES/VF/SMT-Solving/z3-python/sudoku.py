#!/usr/bin/env python
# coding: utf-8

# # Sudoku

# Os puzzles Sudoku são problemas de colocação de números inteiros entre 1 e $N^2$ numa matriz quadrada de dimensão $N^2$, por forma a que cada coluna e cada linha contenha todos os números, sem repetições. Além disso, cada matriz contém $N^2$ sub-matrizes quadradas disjuntas, de dimensão $N$, que deverão também elas conter os números entre  1 e $N^2$.
#
# Cada problema é dado por uma matriz parcialmente preenchida, cabendo ao jogador completá-la.
#
# O problema pode ser codificado através de um conjunto de $N^4$ constantes de tipo inteiro, correspondentes às posições da matriz, e escrevendo:
#
# - $2 \times N^4$ desigualdades para os limites inferior e superior das constantes;
# - $N^2$ restrições do tipo “todos diferentes”, uma para cada linha da matriz;
# - $N^2$ restrições do tipo “todos diferentes”, uma para cada coluna da matriz;
# - $N^2$ restrições do tipo “todos diferentes”, uma para cada sub-matriz da matriz.
#
# Acrescem ainda as restrições (igualdades) correspondentes à definição de um tabuleiro concreto.
#

# In[ ]:


from z3 import *


# Vamos necessitar de uma família de variáveis inteiras $x_{ij}$ e, para isso, vamos criar um dicionário do Python.

# In[ ]:


global N
global linhas
global colunas

N=3
linhas=colunas=pow(N,2)

s = Solver()

x = {}

# restrições de valor em cada bloco
for i in range(linhas):
  x[i] = {}
  for j in range(colunas):
    x[i][j] = Int('x'+str(i)+str(j))
    s.add(And(1<=x[i][j],x[i][j]<=pow(N,2)))

# restrições de linha
for i in range(linhas):
  s.add(Distinct([x[i][j] for j in range(colunas)]))

# restrições de coluna
for j in range(colunas):
  s.add(Distinct([x[i][j] for i in range(linhas)]))

# restrições de região
for a in range(N):
  for b in range(N):
    s.add(Distinct([ x[a*N+i][b*N+j] for i in range(N) for j in range(N) ]))

s.push()

# Tabuleiro

s.add(x[0][0] == 3)
s.add(x[4][3] == 9)
s.add(x[7][1] == 4)
s.add(x[1][6] == 8)
s.add(x[2][8] == 1)
s.add(x[5][3] == 5)
s.add(x[5][0] == 6)

if s.check() == sat:
  m=s.model()
  print(m)
  print('======= Solução =======')
  for i in range(linhas):
    print([m[x[i][j]].as_long() for j in range(colunas) ]) # as_long → ver como inteiro.
else:
  print("Não tem solução.")
