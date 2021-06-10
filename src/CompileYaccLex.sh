#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: CompileYaccLex.sh <yacc>.y <lex>.l"
    exit
fi

yacc -vd --debug --verbose $1
lex $2

gcc y.tab.c lex.yy.c -o iguanacompiler -ll -g

rm lex.yy.* y.tab.* y.output
