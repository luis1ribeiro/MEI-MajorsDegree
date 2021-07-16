#!/usr/bin/python3
import json, os, shutil

# Processamento Informação
with open('individuos.ttl','w+', encoding='utf-8') as individuos:

    # individuos.write('###  http://www.di.uminho.pt/prc2021/EMD#EMD\n')
    # individuos.write(':EMD rdf:type owl:NamedIndividual ,\n')
    # individuos.write('            :EMD ;\n')
    # individuos.write('   :descrição "Exame Médico Desportivo" .\n\n\n')

    with open('dataset.json', encoding='utf-8') as f:
        data = json.load(f)

    dict_atletas={}
    list_modalidades=[]
    list_clubes=[]

    for c in data:
        
        index = c['_id']
        clube = c['clube'].replace(' ', '_')
        m = c['modalidade']
        nome = c['nome']['primeiro'] + ' ' + c['nome']['último']
        g = c['género']
        i = c['idade']
        date = c['dataEMD']
        

        individuos.write('###  http://www.di.uminho.pt/prc2021/EMD#' + str(index) +'\n')
        individuos.write(':' + str(index) +' rdf:type owl:NamedIndividual ,\n')
        individuos.write('            :EMD ;\n')
        individuos.write(f'   :data "' + date + '" .\n')

        individuos.write('###  http://www.di.uminho.pt/prc2021/EMD#' + nome.replace(' ', '_') +'\n')
        individuos.write(':' + nome.replace(' ', '_') +' rdf:type owl:NamedIndividual ,\n')
        individuos.write('            :Atleta ;\n')
        if c['resultado'] == True:
            individuos.write('   :passou :' + str(index) + ' ;\n')
        else:
            individuos.write('   :reprovou :' + str(index) + ';\n')
        individuos.write('   :pertenceA :' + clube + ' ;\n')
        if c['federado'] == True:
            individuos.write('   :federado "True" ;\n')
        else:
            individuos.write('   :federado "False" ;\n')
        individuos.write(f'   :pratica :' + m + ' ;\n')
        individuos.write(f'   :nome "' + nome + '" ;\n')
        individuos.write(f'   :género "' + g + '" ;\n')
        individuos.write(f'   :idade "' + str(i) + '" .\n\n\n')



        if clube not in list_clubes:
            list_clubes.append(clube)
        if m not in list_modalidades:
            list_modalidades.append(m)
    
    for c in list_clubes:
        individuos.write(f'###  http://www.di.uminho.pt/prc2021/EMD#{c}\n')
        individuos.write(f':{c} rdf:type owl:NamedIndividual ,\n')
        individuos.write('            :Clube .\n')
    
    for m in list_modalidades:
        individuos.write(f'###  http://www.di.uminho.pt/prc2021/EMD#{m}\n')
        individuos.write(f':{m} rdf:type owl:NamedIndividual ,\n')
        individuos.write('            :Modalidade .\n')