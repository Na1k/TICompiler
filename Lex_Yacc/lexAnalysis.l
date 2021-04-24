%option noyywrap
%{
	#include<stdio.h>
	#include "y.tab.h"
	int yylineno;

        /*
         * TODO Create dictionary for Variable name & content transfer to yacc
         */
        extern test;
%}
		
%%

 /*
 * TODO swap my_return for specific return based on type
 *
 */

 /*
 * TODO More matches
 */

";"			return MISC_SEMI;
"int"			{return TYPE_INT; printf("INT");};
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
[-+\n]			return *yytext; /* TODO HACK */
[-]?[1-9][0-9]*		{yylval = atoi(yytext); test = 55; return LIT_INT;}
"'"[a-zA-Z_ ]?"'"       return LIT_CHAR;
"TRUE"                  return LIT_BOOL;
"FALSE"                 return LIT_BOOL;

[a-z][a-zA-Z0-9_-]*	{
                                if(yyleng > 49){my_return("ERROR_TOKENLEN");}
                                char str[50];
                                sprintf(str, "VAR_%s", yytext);
                                return VAR;
			}
"("			{printf("LP");return MISC_LP;};
")"			return MISC_RP;
";"                     return MISC_SEMI;

\n			{
				printf("\n");
				yylineno++;
			}
[ \t]			;
"//".*\n                 printf("COMMENT\n");

.			{
                                if(yyleng > 49){my_return("ERROR_TOKENLEN");}
                                char str[50];
                                sprintf(str, "ERROR: %s", yytext);
                                my_return(str);
                        }

%%



int my_return(int token)
{
	//printf("\nZeile %d : ", yylineno);
        printf("MYRETURN %d\n", token);
	return token;
}
