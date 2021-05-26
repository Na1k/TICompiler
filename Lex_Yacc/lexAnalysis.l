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

"&"                     return LOGIC_AND;
"|"                     return LOGIC_OR;
"!"                     return LOGIC_NOT;

 /* XOR */

0			{yylval.nval.type = 0; yylval.nval.ival = 0; return LIT_ZERO;}
[1-9][0-9]*		{yylval.nval.type = 0; yylval.nval.ival = atoi(yytext); return LIT_INT;}
"'"[a-zA-Z0-9_ ]?"'"    {yylval.sval = strdup(yytext); return LIT_CHAR;}
"TRUE"                  {yylval.nval.type = 2; yylval.nval.ival = 1; return LIT_BOOL;}
"FALSE"                 {yylval.nval.type = 2; yylval.nval.ival = 0; return LIT_BOOL;}
([1-9][0-9]*|0)\.[0-9]* {yylval.nval.type = 3; yylval.nval.fval = atof(yytext); return LIT_FLOAT;}
"\""[a-zA-Z0-9_ ]*"\""  {yylval.sval = strdup(yytext); return LIT_STRING;}

"{"                     return ARR_LP;
"}"                     return ARR_RP;
","                     return ARR_SEP;

[a-z][a-zA-Z0-9_-]*	{yylval.sval = strdup(yytext); return VAR;}
			
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
