**Para correr:**

- Basta correr o script *> ./script.sh*. Este script consiste em usar a nossa database *db.json*, e fazer redirect do output para um ficheiro *result.ttl*. Este é inicialmente igual ao *template.ttl*. Basicamente, temos isto:
    - *> flex filter-json2ttl.l*
    - *> gcc lex.yy.c*
    - *> ./a.out < ./database/db.json >> result.ttl*
    - Temos outras operações de rm para facilitar a limpeza da pasta. Sempre que o script é corrido, é criado um novo ficheiro *result.ttl*

- O resultado irá ser adicionado ao ficheiro *result.ttl* na secção ***INDIVIDUALS***, como *append*.
- No ficheiro *result.ttl*, podemos encontrar uma versão após correr o script de preenchimento do *template.ttl*.