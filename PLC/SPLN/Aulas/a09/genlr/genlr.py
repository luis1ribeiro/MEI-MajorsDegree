#!/usr/bin/python3
'''package for aula jj'''
__version__ = "0.1.0"

import yaml, sys, readline

def importGen(file):
  # Import yaml Gen
  with open(file) as f:
    gen = yaml.full_load(f)
  return gen

def pai(c,gen):
  try:
    # código de Família
    cf=gen[c]["pais"]
    # código pai - vou buscar à família
    cp=gen[cf]["pai"]

    # Dá return do nome do Pai
    return gen[cp]["nome"]
  except Exception:
    return None

def mae(c,gen):
  try:
    # código de Família
    cf=gen[c]["pais"]
    # código mae - vou buscar à família
    cp=gen[cf]["mae"]

    # Dá return do nome do Pai
    return gen[cp]["nome"]
  except Exception:
    return None

def pprintInd(c,gen):
  inf=gen[c]
  # Se for indivíduo
  if c[0] == "I":
    print(f'{c} → Nome: {inf["nome"]} -- Mãe: {mae(c,gen)} | Pai: {pai(c,gen)}')

def pprintInds(gen):
  for p in gen:
    pprintInd(p,gen)

# n é um input dado na query.
def searchgen(n,gen):
   for c,inf in gen.items():
       # Se n estiver no nome, então faço o Pretty Print.
       if n in inf.get("nome",""):
          pprintInd(c,gen)
          print("====")

def shellquery():
  gen=importGen(sys.argv[1])
  # Interpretador de comandos
  while True:
      try:
         q = input("? ").strip()
      except KeyboardInterrupt: # Cntrl-C
        sys.exit()

      # add_history permite ir buscar os últimos inputs
      readline.add_history(q)
      searchgen(q,gen)
