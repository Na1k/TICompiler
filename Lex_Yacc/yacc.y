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

        typedef struct SytaxNode{
            int nodeType; //identifieziert die node selbst (eg Int/eqlvl1 etc...)
            union
            {
                int ival;
                float fval;
                char *sval;
            };
            struct SyntaxNode* leftChild;
            struct SyntaxNode* rightChild;
        } SyntaxNode;

        typedef struct Variable {
                char* name;
                Type type;                 
                Flags flags;
                SyntaxNode* value;           //zeigt auf SyntaxNode
                int length;                     //wie viele Bytes?
                struct Variable* next;
        } Variable;


        Variable* root = NULL;

        //Forward-Declaration
        Variable* makeVar(int type, char* name);
        void insertVar(Variable* var, Flags flags);
        void checkVar(Variable* var); //checks if Var exists for assignment
        void printVars();
%}


%union {
        void* var;
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

%type<var> assignment

/*
 * Declare Syntax
 */

%%
program:	program declaration { printf (" -PROG DECLARATION- \n"); }
        |       program assignment {checkVar((Variable*)$2); printf (" -PROG ASSIGN- \n"); }
        |       program controlBlock { printf (" -PROG CTRL- \n"); }
        | ;

declaration:    type VAR MISC_SEMI {insertVar(makeVar($1, $2.sval), E_UNDEF);}
        |       type assignment {insertVar((Variable*)$2, E_VAR);}
        |       CONST_DECL type assignment {insertVar((Variable*)$3, E_CONST);}
        |       type TYPE_ARRAY assignment {insertVar((Variable*)$3, E_ARR);};

assignment:     VAR ASSIGN exprlvl_1 MISC_SEMI {$$ = (void*)makeVar(INT, $1.sval);}
        |       VAR ASSIGN LIT_CHAR MISC_SEMI {$$ = (void*)makeVar(CHAR, $1.sval);}
        |       VAR ASSIGN LIT_STRING MISC_SEMI {$$ = (void*)makeVar(STRING, $1.sval);}
        |       VAR ASSIGN ARR_LP arraystruct ARR_RP MISC_SEMI{$$ = (void*)makeVar(INT, $1.sval);};

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
        printVars();
	return 0;
}

Variable* makeVar(int varType, char* varName){
    Variable* var = (Variable*) malloc(sizeof(Variable));
    var->type = varType;
    var->name = varName;
    var->next = NULL;
    return var;
}

void insertVar(Variable* var, Flags flags){
    var->flags = flags;
    if(!root)
    {
            root = var;
    }
    else
    {
            Variable* tmp = root;

            while(tmp){
                if(strcmp(tmp->name, var->name) == 0){
                        free(var);
                        yyerror("Fehlermeldung, VarName bereits vorhanden");
                        exit(-1);
                }
                if(tmp->next)
                    tmp = tmp->next;
                else
                    break;
            }
            tmp->next = var;
    }
}

void checkVar(Variable* var){

    if(!root)
    {
        free(var);
        yyerror("Fehlermeldung, Var nicht deklariert(in fact, no vars are deklariert)");
        exit(-1);
    }
    else
    {
            Variable* varOld = root;

            while(varOld){
                if(strcmp(varOld->name, var->name) == 0){
                    if(varOld->flags & E_CONST){
                        free(var);
                        yyerror("Fehlermeldung, Neuzuweisung Konstante - pfui");
                        exit(-1);
                    }
                    free(var);
                    return;
                }
                if(varOld->next)
                    varOld = varOld->next;
                else
                    break;
            }
            free(var);
            yyerror("Fehlermeldung, Var nicht deklariert");
            exit(-1);
    }
}

void printVars(){
    Variable* tmp;
    tmp = root;
    int varNum = 0;
    while(tmp){
        printf("%d Type: %d Name: %s Flags: %d\n", varNum, tmp->type, tmp->name, tmp->flags);
        varNum++;
        if(tmp->next)
            tmp = tmp->next;
        else
            break;
    }
}









