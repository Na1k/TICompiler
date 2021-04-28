%{
#include <stdio.h>
int yylex(void);
void yyerror(char*);
/*
 * TODO Create dictionary for Variable name & content transfer to yacc
 */
int lineno = 1;
%}

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

%token ERROR

/*
 * Grammar Tree:
 *
 * Programm
 * |- expr
 */

%%
program:	program declaration { printf (" -PROG DECLARATION- \n"); }
        |       program assignment { printf (" -PROG ASSIGN- \n"); }
        | ;

declaration:    type VAR MISC_SEMI    
        |       type assignment;

assignment:     VAR ASSIGN expr MISC_SEMI;

type:           TYPE_INT
        |       TYPE_CHAR
        |       TYPE_BOOL;

expr:           MISC_LP expr MISC_RP
        |       expr operator expr
        |       number
        |       VAR;

number:         LIT_INT
        |       LIT_ZERO;

operator:       OP_ADD
        |       OP_SUB
        |       OP_MUL
        |       OP_DIV
        |       OP_POT
        |       OP_MOD;

%%

void yyerror (char *s) { fprintf(stderr, "Line %d: %s\n", lineno, s); }
int main(void) { 
	yyparse();
	return 0;
}
