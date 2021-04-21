%option noyywrap
%{
	#include<stdio.h>

	int yylineno;
%}

%%
"if"		my_return ("IF");
"then"		my_return ("THEN");
"else"		my_return ("ELSE");

[a-zA-Z]+	my_return ("ID");

0		my_return ("INTEGER");
[1-9][0-9]'	my_return ("INTEGER");

\n		{printf ("\n\n"); ++yylineno;};

[ \t]		;

.		my_return ("OTHER");

%%

int my_return(char *token)
{
	printf("\nZeile %d : ", yylineno);
	printf("%s", token);
}
int main(){
	yylex();
	printf("Zeilen: %d\n", yylineno-1);
}
