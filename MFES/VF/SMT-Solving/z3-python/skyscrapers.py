#!/usr/bin/env python
# coding: utf-8

# # Skyscrapers

# O Skyscrapers é um puzzle lógico que tem por objectivo organizar arranha-céus num tabuleiro ($N \times N$) de forma a que o seu horizonte seja visível de acordo com as pistas (números colocados nas bordas do tabuleiro que indicam quantos arranha-céus é possível ver daquela posição). Adicionalmente, exige-se que:
#
# - Todos os arranha-céus têm altura entre 1 e $N$.
# - Não podem existir arranha-céus da igual altura numa mesma coluna ou linha.
# - O tabuleiro está inicialmente vazio.
#

# In[ ]:


from z3 import *


# Recorde que na codificação seste puzzle em SMTLIBv2, definiu-se uma função lógica que recebe três argumentos (uma fila da alturas dos arranha-céus) $a_1$, $a_2$ e $a_3$  e devolve o número de prédios visíveis (quando olhamos assim: $\to a_1 \; a_2 \; a_3$).
#
# `(define-fun visible ((a1 Int) (a2 Int) (a3 Int)) Int
#           (ite (= a1 3) 1 (ite (= a2 3) 2 (ite (= a1 1) 3 2))`
#
# O comando `define-fun` está apenas criar uma macro. A API do Z3 não tem suporte para macros, mas podemos criar uma função Python que cria instâncias da macro.
#
#

def visible(a1,a2,a3):
    return If(a1==3, 1, If(a2==3, 2, If(a1==1, 3, 2)))


# Tendo em conta as explicações dadas acima, exprima as restrições necessárias e
# resolva o problema para tabuleiros de dimensão $3 \times 3$.
# Vamos necessitar de uma família de variáveis inteiras $x_{ij}$ .

# completar

s = Solver()

x = {}

# restrições de valor em cada bloco
for i in range(3):
  x[i] = {}
  for j in range(colunas):
    x[i][j] = Int('x'+str(i)+str(j))
    s.add(And(1<=x[i][j],x[i][j]<=3))

# restrições de linha
for i in range(3):
  s.add(Distinct([x[i][j] for j in range(3)]))

# restrições de coluna
for j in range(3):
  s.add(Distinct([x[i][j] for i in range(3)]))

s.push()

s.add( visible(x[0][2],x[0][1],x[0][0]) == 1 )
s.add( visible(x[2][0],x[2][1],x[2][2]) == 2 )
s.add( visible(x[2][2],x[1][2],x[0][2]) == 3 )

if s.check() == sat:
  m=s.model()
  print(m)
  print('======= Solução =======')
  for i in range(3):
    print([m[x[i][j]].as_long() for j in range(3) ]) # as_long → ver como inteiro.
else:
  print("Não tem solução.")


# Uma solução alternativa para criar a macro, é usar quantificadores.
# Pode-se declara a função não interpretada e a crescentar uma restrição
# usando uma fórmula quantificada universalmente:

############ Alternativa ##############

ver = Function('ver', IntSort(), IntSort(), IntSort(), IntSort())

a1, a2, a3 = Ints('a1 a2 a3')

s.add( ForAll([a1,a2,a3], ver(a1,a2,a3) == If(a1==3,1,If(a2==3,2,If (a1==1,3,2)))) )

#s.add(ver(x[0][2],x[0][1],x[0][0]) == 1)
#s.add(ver(x[2][0],x[2][1],x[2][2]) == 2)
#s.add(ver(x[2][2],x[1][2],x[1][2]) == 3)


#
# Experimente esta abordagem.

# In[ ]:




