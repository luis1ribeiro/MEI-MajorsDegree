from jjcli import *

c =clfilter()


for pg in c.input():

    nn = pg.split(',')
    print('###http://www.di.uminho.pt/prc2021/condominios#l'+nn[0].split('/')[1])
    print(':l'+nn[0].split('/')[1]+' rdf:type owl:NamedIndividual, :'+nn[1]+'s;')
    print(':data \"'+ nn[2]+'\";')
    print(':descricao \"' +  nn[5]+'\";')
    print(':valor '+nn[3]+';')
    if nn[1] == "Receita":
        f = nn[4].lower().split()
        n = f[0]
        okok = n[:-1] + f[1]
        print(':origemReceita :'+ okok+'.')
    else:
        print(':fornecedor \"'+nn[4]+'\"'+'.')
