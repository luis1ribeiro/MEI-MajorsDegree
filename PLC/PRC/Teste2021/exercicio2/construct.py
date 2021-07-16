import json, urllib.parse
import requests as reqs

prefixes = '''
        PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
        PREFIX owl: <http://www.w3.org/2002/07/owl#>
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        PREFIX noInferences: <http://www.ontotext.com/explicit>
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        PREFIX : <http://prc.di.uminho.pt/2021/myfamily#>
    '''
getLink = "http://localhost:7200/repositories/family_jcr?query="
upLink = "http://localhost:7200/repositories/family_jcr/statements?update="


# CONSTRUCT IRMÃO
query = '''CONSTRUCT { ?a :Irmão ?b. } 
WHERE {
    ?a :temProgenitor ?p .
    ?b :temProgenitor ?p . 
    
    FILTER (?a != ?b) .
} '''
encoded = urllib.parse.quote(prefixes + query)

# Get da query
resp = reqs.get(getLink + encoded)
resp.raise_for_status()

# Após o Get faço Insert
for line in resp.text.split('.\n'):
    s = line.split()
    if len(s) == 3:
        a = s[0].split('#')[1][:-1]
        b = s[2].split('#')[1][:-1]

        insert = "INSERT DATA { :" + a + " :Irmão" + " :" + b + " . }"
        encoded_ = urllib.parse.quote(prefixes + insert)
            
        resp_ = reqs.post(upLink + encoded_)
        resp_.raise_for_status()
