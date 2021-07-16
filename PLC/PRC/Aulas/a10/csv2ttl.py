import csv

with open('jcr_family.csv', newline='') as csvfile:
    data = list(csv.reader(csvfile))[1:]

for ind in data:
    print('###  http://www.di.uminho.pt/prc2021/myfamily#' + ind[0].strip().replace(' ','_'))
    print(f'\t:{ind[0].strip().replace(" ", "_")} rdf:type owl:NamedIndividual ;')
    print(f'\t\t:temMae :{ind[2].strip().replace(" ", "_")} ;')
    print(f'\t\t:temPai :{ind[1].strip().replace(" ", "_")} .')
