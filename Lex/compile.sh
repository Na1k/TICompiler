#!/bin/bash

flex $1
gcc lex.yy.c -lfl
#rm lex.yy.c
