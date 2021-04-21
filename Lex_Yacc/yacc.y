%{
#include <stdio.h>
yylex(void);
void yyerror(char*);
%}

%token INTEGER

%%
program:	program expr '\n'{ printf ("PROG: %d\n", $2); }
	| ;
expr:		INTEGER { $$ = $1;}
	|	expr '+' expr { $$ = $1 + $3;}
	|	expr '-' expr { $$ = $1 - $3;};
%%

void yyerror (char *s) { fprintf(stderr, "YYERR: %s\n", s); }
int main(void) { 
	yyparse();
	return 0;
}
