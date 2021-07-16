import re,sys
from random import choice
import unidecode

def genemails (name : str) ->  [str] :

    temp = ''
    name = name.lower()
    # Tirar acentos → Uniformizar os nomes.
    name=unidecode.unidecode(name)
    emails = []
    name = re.sub(r'( d[ae]| dos|\.)',' ',name)
    names = name.split()

    # Nome Próprio + Apelido
    # Sofia Oliveira Lopes :: sofialopes
    emails.append(names[0]+names[-1])

    # Nome Próprio
    # Jacinta Maciel :: jacinta
    emails.append(names[0])

    # Apelido
    # António Luís Duarte Costa :: costa
    emails.append(names[-1])

    # Primeira letra do nome próprio + apelido
    # João Gonçalves :: jgoncalves
    emails.append(names[0][0]+names[-1])

    # As 4 primeiras letras do nome próprio
    # Alexandre Júlio Teixeira Santos :: alex
    emails.append(names[0][0:4])

    # Primeira Letra do Nome Próprio e do Apelido
    # António José Borba Ramires Fernandes :: af
    emails.append(names[0][0]+names[-1][0])

    # Primeira Letra do Nome Próprio, do segundo Nome e do Apelido
    # António José Pinheiro Coutinho :: ajc
    emails.append(names[0][0]+names[1][0]+names[-1][0])

    # Primeira Letra do Nome Próprio, do penúltimo Nome e do Apelido
    # António Manuel Nestor Ribeiro :: anr
    emails.append(names[0][0]+names[-2][0]+names[-1][0])

    # Segundo Nome
    # Manuel Alcino Pereira da Cunha :: alcino
    emails.append(names[1])

    # Terceiro Nome
    # José Carlos Bacelar Ferreira J. Almeida :: bacelar
    if len(names)>2 :
        emails.append(names[2])

    # Nome Próprio.Apelido
    # José Francisco Creissac Freitas Campos :: jose.campos
    emails.append(names[0]+'.'+names[-1])

    # Primeira Letra do Nome Próprio_Apelido
    # Rui Manuel da Silva Ralha :: r_ralha
    emails.append(names[0][0]+'_'+names[-1])

    # Todas as iniciais do nome completo
    for n in names:
        temp+=n[0]
    emails.append(temp)
    temp=''

    # Iniciais do nome + Apelido
    # Nuno Alexandre Ramos de Carvalho :: narcarvalho
    for i in range(len(names)-1):
        temp+=names[i][0]
    temp+=names[-1]
    emails.append(temp)
    temp=''

    # Primeira Letra do Nome Próprio +  Três primeiras letras do Apelido
    # José Manuel Ferreira Machado :: jmac
    emails.append(names[0][0]+names[-1][0:3])

    # Primeira Letra das posições pares
    # Pedro Manuel Rangel S. Henriques :: prh
    for i in range(0,len(names),2):
        temp+=names[i][0]
    emails.append(temp)

    #Primeira Letra do segundo nome + Apelido
    #Luís Paulo Peixoto dos Santos :: psantos
    emails.append(names[1][0]+names[-1])

    #Primeira Letra do Nome Próprio e segundo nome
    #José João Antunes G.D. Almeida :: jj
    emails.append(names[0][0]+names[1][0])

    #Primeira Letra do nome próprio,segundo nome,penúltimo nome e apelido
    #Paulo Jorge Freitas Oliveira Novais :: pjon
    emails.append(names[0][0]+names[1][0]+names[-2][0]+names[-1][0])

    return emails
