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

";"			my_return("");
"int"			my_return("TYPE_INT");

"if"			my_return("IF");
    /* CTRL_IF CTRL_ELSE
     *
     */
"else"			my_return("ELSE");

0			my_return(ZERO);
[-+\n]			return *yytext; /* TODO HACK */
[-]?[1-9][0-9]*		{yylval = atoi(yytext); test = 55; return NUM_INT;}


[a-z][a-zA-Z0-9_-]*	{
                                if(yyleng > 49){my_return("ERROR_TOKENLEN");}
                                char str[50];
                                sprintf(str, "VAR_%s", yytext);
                                my_return(str);
			}
"="			my_return("EQUAL");
"("			my_return("LP");
")"			my_return("RP");

\n			{
				printf("\n");
				yylineno++;
			}
[ \t]			;

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
        printf("%d\n", token);
	return token;
}
