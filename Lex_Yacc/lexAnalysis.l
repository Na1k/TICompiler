%option noyywrap
%{
	#include<stdio.h>
	#include "y.tab.h"
	int yylineno;
%}
		
%%
";"			my_return("");
"int"			my_return("TYPE_INT");			

"if"			my_return("IF");
"else"			my_return("TYPE_ELSE");

0			my_return("ZERO");
[-]?[1-9][0-9]*		{yylval = atoi(yytext); return INTEGER;}

[-+\n]			return *yytext;

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

int my_return(char *token)
{
	//printf("\nZeile %d : ", yylineno);
	printf("%s\n", token);
	return token;
}
