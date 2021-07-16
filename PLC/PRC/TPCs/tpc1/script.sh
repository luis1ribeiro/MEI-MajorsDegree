#!/bin/bash

file1="./result.ttl"
if [ -e "$file1" ]; then
		rm result.ttl
fi
x=$(cat template.ttl) && echo "$x" >> result.ttl
flex filter-json2ttl.l
gcc lex.yy.c
./a.out < ./database/db.json >> result.ttl
rm lex.yy.c ./a.out