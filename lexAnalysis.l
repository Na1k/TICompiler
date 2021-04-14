%option noyywrap
%{
	#include<stdio.h>
	int yylineno;
%}
		
%%
";"			my_return("");
"int"			my_return("TYPE_INT");			
0			my_return("ZERO");
[-]?[1-9][0-9]*		my_return(yytext);

[a-z][a-zA-Z0-9_-]*	my_return(sprintf("VAR_%s",yytext));
"="			my_return("EQUAL");
"("			my_return("LP");
")"			my_return("RP");

\n			printf("\n");
[ \t]			;

.			my_return(sprintf("ERROR: %s", yytext));

%%

int my_return(char *token)
{
	//printf("\nZeile %d : ", yylineno);
	printf("%s\n", token);
}
int main(){
	yylex();
	printf("Zeilen: %d\n", yylineno-1);
}
