%{
        #include <stdio.h>
        #include <string.h>
        #include <stdlib.h>
        int yylex(void);
        void yyerror(char*);

/*
 * TODO Create dictionary for Variable name & content transfer to yacc
 * constants
 */
        int lineno = 1;

        typedef enum Type {
                INT = 0,
                CHAR,
                BOOL,
                FLOAT,
                STRING
        } Type;

        typedef enum Flags {
                E_CONST = 0x01,   //0001
                E_VAR = 0x02,     //0010
                E_ARR = 0x04,      //0100
                E_UNDEF = 0x08
        } Flags;

        typedef struct Variable {
                char* name;
                Type type;                 
                Flags flags;
                unsigned char* value;           //zeigt auf 1 Byte
                int length;                     //wie viele Bytes?
                struct Variable* next;
        } Variable;

        Variable* root = NULL;

        //Forward-Declaration
        void makeVar(int type, char* name, int nameLen);
%}


%union {
        struct Data 
        {
                int type;
                union
                {
                        int ival;
                        float fval;
                        char *sval;
                };
                
        } data;
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

%token <data> VAR

/* TYPES */
%token TYPE_INT 
%token TYPE_CHAR
%token TYPE_BOOL
%token TYPE_FLOAT      
%token TYPE_STRING     
%token TYPE_ARRAY       

%token ARR_LP
%token ARR_RP
%token ARR_SEP

%token <data> LIT_INT /* int literal */
%token <data> LIT_BOOL /* true, false */
%token <data> LIT_CHAR
%token <data> LIT_ZERO
%token <data> LIT_STRING
%token <data> LIT_FLOAT

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

%type <data.type> type
%type <data> number
%type <data> literal
%type <data> exprlvl_1
%type <data> exprlvl_2
%type <data> exprlvl_3
%type <data> exprlvl_4

/*
 * Declare Syntax
 */

%%
program:	program declaration { printf (" -PROG DECLARATION- \n"); }
        |       program assignment { printf (" -PROG ASSIGN- \n"); }
        |       program controlBlock { printf (" -PROG CTRL- \n"); }
        | ;

declaration:    type VAR MISC_SEMI {makeVar($1, $2.sval, 10);}
        |       type assignment
        |       CONST_DECL type assignment
        |       type TYPE_ARRAY assignment;

assignment:     VAR ASSIGN exprlvl_1 MISC_SEMI {printf("%d", $3.ival);}
        |       VAR ASSIGN LIT_CHAR MISC_SEMI {printf("%s", $3.sval);}
        |       VAR ASSIGN LIT_STRING MISC_SEMI {printf("%s", $3.sval);}; 
        |       VAR ASSIGN ARR_LP arraystruct ARR_RP MISC_SEMI;

arraystruct:    arrayitems
        |       arrayitems ARR_SEP arraystruct;  

arrayitems:     exprlvl_1
        |       LIT_CHAR
        |       LIT_STRING 

type:           TYPE_INT {$$=0;}
        |       TYPE_FLOAT {$$=3;}
        |       TYPE_CHAR {$$=1;}
        |       TYPE_STRING {$$=4;}
        |       TYPE_BOOL {$$=2;};


exprlvl_1:      exprlvl_1 logicOperator exprlvl_2 {} 
        |       exprlvl_2 {$$=$1;};

exprlvl_2:      exprlvl_2 lineOperator exprlvl_3 {}
        |       exprlvl_3 {$$=$1;};

exprlvl_3:      exprlvl_3 pointOperator exprlvl_4 {}
        |       exprlvl_4 {$$=$1;};   

exprlvl_4:      exprlvl_4 potOperator literal {}
        |       literal {$$=$1;};


literal:        MISC_LP exprlvl_1 MISC_RP {}       
        |       LIT_BOOL {$$=$1;} 
        |       number {$$=$1;}
        |       VAR {$$=$1;}; 

number:         LIT_INT {$$ = $1;}
        |       LIT_FLOAT {printf("%f %d",$1.fval, $1.type); $$ = $1;}
        |       LIT_ZERO {printf("%d %d", $1.ival, $1.type); $$ = $1;}
        |       OP_SUB LIT_INT {$2.ival = -$2.ival; printf("%d",$2.ival); $$ = $2;}        /* negative number */
        |       OP_SUB LIT_FLOAT {printf("%f",$2.fval); $$ = $2;};

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

void makeVar(int varType, char* varName, int nameLen){
        Variable* var = (Variable*) malloc(sizeof(Variable));
        var->type = varType;
        var->name = varName;
        (void)nameLen;
        var->next = NULL;

        if(root == NULL)
        {
                root = var;     
        }
        else
        {
                Variable* tmp = root;
                
                while (tmp->next){
                        if(strcmp(tmp->name, var->name) == 0){
                                free(var);
                                yyerror("Fehlermeldung, VarName bereits vorhanden");
                                exit(-1);
                        }
                        tmp = tmp->next;
                }
                if(strcmp(tmp->name, var->name) == 0){
                        free(var);
                        yyerror("Fehlermeldung, VarName bereits vorhanden");
                        exit(-1);
                }
                tmp->next = var;
        
        }
}