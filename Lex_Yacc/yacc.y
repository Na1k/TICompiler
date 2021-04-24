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


%token OP_ADD
%token OP_SUB
%token OP_MUL
%token OP_DIV
%token OP_POT /* Potenzen */
%token OP_MOD

%token ASSIGN /* = */

%token COMP_EQL /* == */
%token COMP_LT  /* <  */
%token COMP_LE  /* <= */
%token COMP_GT  /* >  */
%token COMP_GE  /* >= */

%token VAR

%token TYPE_INT 
%token TYPE_CHAR
%token TYPE_BOOL
/*? float double short long unsigned ?*/

%token LIT_INT /* int literal */
%token LIT_BOOL /* true, false */
%token LIT_CHAR
%token LIT_ZERO

%token CTRL_IF
%token CTRL_THEN
%token CTRL_ELSE
%token CTRL_ELIF
%token CTRL_END
%token CTRL_WHILE /* DO ... WHILE exp END | WHILE exp DO ... END */
%token CTRL_DO

%token MISC_LP
%token MISC_RP
%token MISC_SEMI

/*
 * Grammar Tree:
 *
 * Programm
 * |- expr
 */

%%
program:	program expr '\n'{ printf ("PROG: %d\n", $2); }
        | ;

expr:		LIT_INT { printf("INT: %d\n", $1); $$ = $1;}
        |       LIT_ZERO {printf("LIT_ZERO: %d\n", $1); $$ = $1; /* TODO Where does the ZERO go? */
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
