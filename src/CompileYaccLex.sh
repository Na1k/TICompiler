#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: CompileYaccLex.sh <yacc>.y <lex>.l <progname>"
    exit
fi

yacc -vd --debug --verbose $1
lex $2

gcc y.tab.c lex.yy.c -std=c11 -Wall -o $3 -ll -g

#rm lex.yy.* y.tab.* y.output
