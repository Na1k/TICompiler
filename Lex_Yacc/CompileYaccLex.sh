#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: CompileYaccLex.sh <yacc>.y <lex>.l <progname>"
    exit
fi

yacc -d $1
lex $2
gcc -c y.tab.c
gcc -c lex.yy.c

gcc -o $3 y.tab.o lex.yy.o -ll

rm lex.yy.* y.tab.*