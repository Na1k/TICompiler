%{
#include <stdio.h>
int yylex(void);
void yyerror(char*);

/*
 * TODO Create dictionary for Variable name & content transfer to yacc
 * constants
 */
int lineno = 1;
%}

%union {
        int ival;
        char *sval;
}

%token OP_ADD
%token OP_SUB
%token OP_MUL
%token OP_DIV
%token OP_POT /* Potenzen */
%token OP_MOD

%token CONST_DECL

%token ASSIGN /* = */

%token COMP_EQL /* == */
%token COMP_LT  /* <  */
%token COMP_LE  /* <= */
%token COMP_GT  /* >  */
%token COMP_GE  /* >= */

%token LOGIC_AND  /* & */
%token LOGIC_OR  /* | */
%token LOGIC_NOT  /* ! */

%token VAR

/* TYPES */
%token TYPE_INT 
%token TYPE_CHAR
%token TYPE_BOOL
%token TYPE_FLOAT       /* TODO: LIT FLOAT */
%token TYPE_STRING      /* TODO: LIT STRING*/
%token TYPE_ARRAY       

%token ARR_LP
%token ARR_RP
%token ARR_SEP

%token <ival> LIT_INT /* int literal */
%token LIT_BOOL /* true, false */
%token <sval> LIT_CHAR
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
 * Declare Syntax
 */

%%
program:	program declaration { printf (" -PROG DECLARATION- \n"); }
        |       program assignment { printf (" -PROG ASSIGN- \n"); }
        |       program controlBlock { printf (" -PROG CTRL- \n"); }
        | ;

declaration:    type VAR MISC_SEMI    
        |       type assignment
        |       CONST_DECL type assignment
        |       type TYPE_ARRAY assignment;

assignment:     VAR ASSIGN exprlvl_1 MISC_SEMI
        |       VAR ASSIGN LIT_CHAR MISC_SEMI {printf("%s", $3);}
        |       VAR ASSIGN ARR_LP arraystruct ARR_RP MISC_SEMI;

arraystruct:    arrayitems
        |       arrayitems ARR_SEP arraystruct;  

arrayitems:     exprlvl_1
        |       LIT_CHAR; 

type:           TYPE_INT
        |       TYPE_FLOAT
        |       TYPE_CHAR
        |       TYPE_STRING
        |       TYPE_BOOL;


exprlvl_1:      exprlvl_1 logicOperator exprlvl_2 
        |       exprlvl_2;

exprlvl_2:      exprlvl_2 lineOperator exprlvl_3
        |       exprlvl_3;

exprlvl_3:      exprlvl_3 pointOperator exprlvl_4
        |       exprlvl_4;   

exprlvl_4:      exprlvl_4 potOperator literal
        |       literal;


literal:        MISC_LP exprlvl_1 MISC_RP       
        |       LIT_BOOL
        |       number
        |       VAR;

number:         LIT_INT {printf("%d",$1);}
        |       LIT_ZERO
        |       OP_SUB LIT_INT;         /* negative number */

lineOperator:   OP_ADD
        |       OP_SUB;      
        
pointOperator:  OP_MUL
        |       OP_DIV
        |       OP_MOD;

potOperator:    OP_POT;

logicOperator:  COMP_EQL
        |       COMP_LT
        |       COMP_LE
        |       COMP_GT
        |       COMP_GE

        |       LOGIC_AND
        |       LOGIC_OR;

/* if / while / control-structures */

controlBlock:   controlIf       
        |       controlWhile;

controlIf:      CTRL_IF exprlvl_1 CTRL_THEN program controlElif CTRL_END
        |       CTRL_IF exprlvl_1 CTRL_THEN program controlElif CTRL_ELSE program CTRL_END;

controlElif:    CTRL_ELIF exprlvl_1 CTRL_THEN program controlElif
        |;

controlWhile:   CTRL_WHILE exprlvl_1 CTRL_DO program CTRL_END
        |       CTRL_DO program CTRL_WHILE exprlvl_1 CTRL_END;


%%

void yyerror (char *s) { fprintf(stderr, "Line %d: %s\n", lineno, s); }
int main(void) { 
	yyparse();
	return 0;
}
