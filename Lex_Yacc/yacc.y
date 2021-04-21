%{
#include <stdio.h>
yylex(void);
void yyerror(char*);
/*
 * TODO Create dictionary for Variable name & content transfer to yacc
 */
int test = 0;
%}

/*
 * TODO add more tokens
 */

%token NUM_INT
%token ZERO


/*
 * Grammar Tree:
 *
 * Programm
 * |- expr
 */

%%
program:	program expr '\n'{ printf ("PROG: %d\n", $2); }
        | ;

expr:		NUM_INT { printf("INT: %d\n", $1); $$ = $1;}
        |       ZERO {printf("ZERO: %d\n", $1); $$ = $1; /* TODO Where does the ZERO go? */
                       printf("%d \n", yylval);
                     }
        |	expr '+' expr { printf("EXPR: %d + %d\n", $1, $3); $$ = $1 + $3;}
        |	expr '-' expr { printf("EXPR: %d - %d\n", $1, $3);$$ = $1 - $3;};

%%

void yyerror (char *s) { fprintf(stderr, "YYERR: %s\n", s); }
int main(void) { 
	yyparse();
	return 0;
}
