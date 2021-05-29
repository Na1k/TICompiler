%option noyywrap
%{
	#include <stdio.h>
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
"float"                 return TYPE_FLOAT;
"string"                return TYPE_STRING;
"["[1-9][0-9]*"]"       return TYPE_ARRAY;                    

"const"                 return CONST_DECL;

("if"|"IF")		return CTRL_IF;
("else"|"ELSE")		return CTRL_ELSE;
("elif"|"ELIF")         return CTRL_ELIF;
("then"|"THEN")         return CTRL_THEN;
("end"|"END")           return CTRL_END;
("while"|"WHILE")       return CTRL_WHILE;
("do"|"DO")             return CTRL_DO;

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

"&"                     return LOGIC_AND;
"|"                     return LOGIC_OR;
"!"                     return LOGIC_NOT;

 /* XOR */

0			{yylval.data.type = 0; yylval.data.ival = 0; return LIT_ZERO;}
[1-9][0-9]*		{yylval.data.type = 0; yylval.data.ival = atoi(yytext); return LIT_INT;}
"'"[a-zA-Z0-9_ ]?"'"    {yylval.data.type = 1; yylval.data.sval = strdup(yytext); return LIT_CHAR;}
("TRUE"|"true")         {yylval.data.type = 2; yylval.data.ival = 1; return LIT_BOOL;}
("FALSE"|"false")       {yylval.data.type = 2; yylval.data.ival = 0; return LIT_BOOL;}
([1-9][0-9]*|0)\.[0-9]* {yylval.data.type = 3; yylval.data.fval = atof(yytext); return LIT_FLOAT;}
"\""[a-zA-Z0-9_ ]*"\""  {yylval.data.type = 4; yylval.data.sval = strdup(yytext); return LIT_STRING;}

"{"                     return ARR_LP;
"}"                     return ARR_RP;
","                     return ARR_SEP;

[a-z][a-zA-Z0-9_-]*	{yylval.varName = strdup(yytext); return VAR;}
			
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
