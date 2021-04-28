%option noyywrap
%{
	#include<stdio.h>
	#include "y.tab.h"

        /*
         * TODO Create dictionary for Variable name & content transfer to yacc
         */
        extern int lineno;
%}
		
%%

";"			return MISC_SEMI;
"int"			return TYPE_INT;
"char"                  return TYPE_CHAR;
"bool"                  return TYPE_BOOL;

"if"			return CTRL_IF;
"else"			return CTRL_ELSE;
"elif"                  return CTRL_ELIF;
"then"                  return CTRL_THEN;
"end"                   return CTRL_END;
"while"                 return CTRL_WHILE;
"do"                    return CTRL_DO;

"+"                     return OP_ADD;
"-"                     return OP_SUB;
"*"                     return OP_MUL;
"/"                     return OP_DIV;
"^"                     return OP_POT;
"%"                     return OP_MOD;

"="                     return ASSIGN;

"=="                    return COMP_EQL;
"<"                     return COMP_LT;
"<="                    return COMP_LE;
">"                     return COMP_GT;
">="                    return COMP_GE;

0			return LIT_ZERO;
[-]?[1-9][0-9]*		return LIT_INT;
"'"[a-zA-Z_ ]?"'"       return LIT_CHAR;
"TRUE"                  return LIT_BOOL;
"FALSE"                 return LIT_BOOL;

[a-z][a-zA-Z0-9_-]*	return VAR;
			
"("			return MISC_LP;
")"			return MISC_RP;

\n			{
				lineno++;
			}
[ \t]			;
"//".*\n                 printf("COMMENT\n");

.			{
                                return ERROR;
                        }

%%