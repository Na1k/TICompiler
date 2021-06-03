%{
        #include <stdio.h>
        #include <string.h>
        #include <stdarg.h>
        #include <stdlib.h>
        #include "thunderstruct.h"

        int lineno = 1;
        Variable* root = NULL;

        //Forward-Declaration
        int yylex(void);
        void yyerror(char*);

        Variable* makeVar(int type, char* name);        //create a Variable construct. Used to store in Datastructure
        void insertVar(Variable* var, Flags flags);     //insert Var into struct "Variable"
        void assignVar(Variable* var);                  //checks if Var exists for assignment
        void printVars();                               //print all nodes in "Variable" (last action of program, called in main)
        Variable* getVar(char* name);                   //retrieve Var from datastructure for insertion on right hand side of assignment
        SyntaxNode* makeNode(int nodeType, int valueType, ...);
%}


%union {
        void* content;
        int type;
}

%token OP_ADD
%token OP_SUB
%token OP_MUL
%token OP_DIV 
%token OP_POT   //Potenzen
%token OP_MOD

%token CONST_DECL

%token ASSIGN   // =

%token COMP_EQL         // == 
%token COMP_LT          // <  
%token COMP_LE          // <= 
%token COMP_GT          // >  
%token COMP_GE          // >= 

%token LOGIC_AND        // & 
%token LOGIC_OR         // | 
%token LOGIC_NOT        // ! 

%token <content> VAR

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

%token <content> LIT_INT   // int literal 
%token <content> LIT_BOOL  // true, false 
%token <content> LIT_CHAR
%token <content> LIT_ZERO
%token <content> LIT_STRING
%token <content> LIT_FLOAT

%token CTRL_IF
%token CTRL_THEN
%token CTRL_ELSE
%token CTRL_ELIF
%token CTRL_END
%token CTRL_WHILE       // DO ... WHILE exp END | WHILE exp DO ... END 
%token CTRL_DO

%token MISC_LP
%token MISC_RP
%token MISC_SEMI

%token DEBUG
%token ERROR

%type <type> type
%type <content> number
%type <content> literal
%type <content> exprlvl_1
%type <content> exprlvl_2
%type <content> exprlvl_3
%type <content> exprlvl_4

%type <content> assignment

/*
 * Declare Syntax
 */

%%
program:	program declaration { printf (" -PROG DECLARATION- \n"); }
        |       program assignment {assignVar((Variable*)$2); printf (" -PROG ASSIGN- \n"); }
        |       program controlBlock { printf (" -PROG CTRL- \n"); }
        |       program DEBUG MISC_LP LIT_STRING MISC_RP MISC_SEMI { printf("debug: %s \n", ((Data*)$4)->sval);}
        |;

declaration:    type VAR MISC_SEMI {insertVar(makeVar($1, ((Data*)$2)->sval), E_UNDEF);}
        |       type assignment {insertVar((Variable*)$2, E_VAR);}
        |       CONST_DECL type assignment {insertVar((Variable*)$3, E_CONST);}
        |       type TYPE_ARRAY assignment {insertVar((Variable*)$3, E_ARR);};

assignment:     VAR ASSIGN exprlvl_1 MISC_SEMI {$$ = (void*)makeVar(INT, ((Data*)$1)->sval);}
        |       VAR ASSIGN LIT_CHAR MISC_SEMI {$$ = (void*)makeVar(CHAR, ((Data*)$1)->sval);}
        |       VAR ASSIGN LIT_STRING MISC_SEMI {$$ = (void*)makeVar(STRING, ((Data*)$1)->sval);}
        |       VAR ASSIGN ARR_LP arraystruct ARR_RP MISC_SEMI{$$ = (void*)makeVar(INT, ((Data*)$1)->sval);};

arraystruct:    arrayitems
        |       arrayitems ARR_SEP arraystruct;  

arrayitems:     exprlvl_1
        |       LIT_CHAR
        |       LIT_STRING 

type:           TYPE_INT {$$=INT;}
        |       TYPE_FLOAT {$$=FLOAT;}
        |       TYPE_CHAR {$$=CHAR;}
        |       TYPE_STRING {$$=STRING;}
        |       TYPE_BOOL {$$=BOOL;};


exprlvl_1:      exprlvl_1 logicOperator exprlvl_2 {}
        |       exprlvl_2 {$$=$1;};

exprlvl_2:      exprlvl_2 lineOperator exprlvl_3 {}
        |       exprlvl_3 {$$=$1;};

exprlvl_3:      exprlvl_3 pointOperator exprlvl_4 {}
        |       exprlvl_4 {$$=$1;};   

exprlvl_4:      exprlvl_4 potOperator literal {}
        |       literal {$$=$1;};


literal:        MISC_LP exprlvl_1 MISC_RP {}
        |       LOGIC_NOT MISC_LP exprlvl_1 MISC_RP {}
        |       LIT_BOOL {$$=$1;} 
        |       number {$$=$1;}
        |       VAR {$$=(void*)getVar(((Data*)$1)->sval);} 
        |       OP_SUB VAR {};

number:         LIT_INT {$$ = $1;}
        |       LIT_FLOAT {printf("%f %d",((Data*)$1)->fval, ((Data*)$1)->type); $$ = $1;}
        |       LIT_ZERO {printf("%d %d", ((Data*)$1)->ival, ((Data*)$1)->type); $$ = $1;}
        |       OP_SUB LIT_INT {((Data*)$2)->fval = -((Data*)$2)->ival; printf("%d",((Data*)$2)->ival); $$ = $2;}        /* negative number */
        |       OP_SUB LIT_FLOAT {((Data*)$2)->fval = -((Data*)$2)->fval; printf("%f",((Data*)$2)->fval); $$ = $2;};

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
        makeNode(0,0,4);
        makeNode(0,1,4.3);
        makeNode(0,2,"0,1 Promille");
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

void assignVar(Variable* var){
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
                    if(varOld->flags & E_CONST)
                    {
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


Variable* getVar(char* name){
        Variable* tmp;
        tmp = root;
        while(tmp){
                if(strcmp(tmp->name, name) == 0){
                    return tmp;
                }
                if(tmp->next)
                    tmp = tmp->next;
                else
                    break;
        }
        yyerror("Fehlermeldung, Var (rechte Seite) nicht deklariert");
        exit(-1);        
}

//makenode(type, datentyp, value, lchild, rchild);
//makenode(type, valType, val);

SyntaxNode* makeNode(int nodeType, int valueType, ...){
    va_list args; // 👈 check it out!
    SyntaxNode* node blabla malloc etc pp;
    va_start(args, valueType);

    node->type = ??; // 👈 hier smartness einfügen
    node->valueType = valueType;

    switch (valueType) {
    case 0:
        node->ival = va_arg(args, int);
        ...;
    case 1:
        printf("%f\n", va_arg(args, double));
        break;
    case 2:
        printf("%s\n", va_arg(args, char*));
        break;
    }

    node-> lchild = va_arg(args, SyntaxNode*);
    ...;
    int x = va_arg(args, int);
    printf("%d\n", x);
    va_end(args);
    return NULL;
}





