import json, urllib.parse
import requests as reqs

prefixes = '''
        PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
        PREFIX owl: <http://www.w3.org/2002/07/owl#>
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        PREFIX noInferences: <http://www.ontotext.com/explicit>
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        PREFIX : <http://www.di.uminho.pt/prc2021/mapa-virtual#>
    '''
getLink = "http://localhost:7200/repositories/mava-virtual?query="
upLink = "http://localhost:7200/repositories/mava-virtual/statements?update="


# Query feita em aula.
query = '''CONSTRUCT { ?c1 :temLigação ?c2 . } 
        WHERE { ?l :origem ?c1. ?l :destino ?c2. } '''
encoded = urllib.parse.quote(prefixes + query)

resp = reqs.get(getLink + encoded)
resp.raise_for_status()

for l in resp.text.split('.\n'):
    s = l.split()
    if len(s) == 3:
        c1 = s[0].split('#')[1][:-1]
        c2 = s[2].split('#')[1][:-1]
        # print(c1,c2)

        insert = "INSERT DATA { :" + c1 + " :temLigação" + " :" + c2 + " . }"
        encoded_ = urllib.parse.quote(prefixes + insert)
            
        resp_ = reqs.post(upLink + encoded_)
        resp_.raise_for_status()
