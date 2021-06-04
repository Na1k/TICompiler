%{
        #include <stdio.h>
        #include <string.h>
        #include <stdarg.h>
        #include <stdlib.h>
        #include "thunderstruct.h"

        #define IGUANADEBUG

        extern FILE *yyin;
        int lineno = 1;
        Variable* varRoot = NULL;
        SyntaxNode* progRoot = NULL;

        //Forward-Declaration
        int yylex(void);
        void yyerror(char*);

        Variable* makeVar(int type, char* name);        //create a Variable construct. Used to store in Datastructure
        void insertVar(Variable* var, Flags flags);     //insert Var into struct "Variable"
        void assignVar(Variable* var);                  //checks if Var exists for assignment
        void printVars();                               //print all nodes in "Variable" (last action of program, called in main)
        Variable* getVar(char* name);                   //retrieve Var from datastructure for insertion on right hand side of assignment
        SyntaxNode* makeNode(int nodeType, int valueType, ...);
        float getNumVal(Data* data);
        void printNode(SyntaxNode* node);
        void printProgTree(SyntaxNode* prog);

        //debug
        void dprint(char* text);
%}


%union {
        void* content;
        int type;
        char* opString;
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

%type <content> program

%type <content> declaration
%type <content> assignment

%type <content> arraystruct
%type <content> arrayitems

%type <opString> lineOperator
%type <opString> pointOperator
%type <opString> potOperator
%type <opString> logicOperator

/*
 * Declare Syntax
 */

%%
program:	program declaration
                {
//                    char* varName;
                    printf (" -PROG DECLARATION-  (1)\n");
                    SyntaxNode* node = makeNode(E_OPERATION, STRING, "Prog", $1, $2);
                    progRoot = node;
                    $$ = node;
                    dprint("\n");
                }
        |       program assignment
                {
                    printf (" -PROG ASSIGN-  (1)\n");
                    SyntaxNode* node = makeNode(E_OPERATION, STRING, "Prog", $1, $2);
                    progRoot = node;
                    $$ = node;
                    dprint("\n");
                    //assignVar((Variable*)$2)
                }
        |       program controlBlock
                {
//                     SyntaxNode* ret = makeNode(E_OPERATION, STRING, "Prog", $1, $2);
                    dprint("\n");
                }

        |       program DEBUG MISC_LP LIT_STRING MISC_RP MISC_SEMI { printf("debug: %s \n", ((Data*)$4)->sval);}
        |       {
                    printf(" -EMPTY- \n");
                    dprint("Made the EMPTY Node (1)\n\n");
                    $$ = NULL;
                };

declaration:    type VAR MISC_SEMI
                {
                    dprint(" -DECL UNDEF- (3)\n");
                    $$ = makeNode(E_OPERATION, STRING, "DECL", makeNode(E_VALUE, INT, $1), makeNode(E_VALUE, VARIABLE, ((Data*)$2)->sval));
                    insertVar(makeVar($1, ((Data*)$2)->sval), E_UNDEF);
                }
        |       type assignment
                {
                    dprint(" -DECL ASSIGN- (2)\n");
                    $$ = makeNode(E_OPERATION, STRING, "DECL", makeNode(E_VALUE, INT, $1), $2);
                    insertVar(makeVar(((SyntaxNode*)$2)->rightChild->expressionType,((SyntaxNode*)$2)->leftChild->sval), E_VAR);
                }
        |       CONST_DECL type assignment
                {
                    dprint(" -DECL CONST- (2)\n");
                    $$ = makeNode(E_OPERATION, STRING, "DECL", makeNode(E_VALUE, INT, $2), $3);
                    insertVar(makeVar(((SyntaxNode*)$3)->rightChild->expressionType, ((SyntaxNode*)$3)->leftChild->sval), E_CONST);
                }
        |       type TYPE_ARRAY assignment
                {
                    dprint(" -DECL ARRAY- (2)\n");
                    $$ = makeNode(E_OPERATION, STRING, "DECL", makeNode(E_VALUE, INT, $1), $3);
                    insertVar(makeVar(((SyntaxNode*)$3)->rightChild->expressionType, ((SyntaxNode*)$3)->leftChild->sval), E_ARR);
                };

assignment:     VAR ASSIGN exprlvl_1 MISC_SEMI
                {
                    dprint(" -ASSIGN EXPR- (2)\n");
                    $$ = makeNode(E_OPERATION, STRING, "=", makeNode(E_VALUE, VARIABLE, ((Data*)$1)->sval), $3);
                }
        |       VAR ASSIGN LIT_CHAR MISC_SEMI
                {
                    dprint(" -ASSIGN CHAR- (3)\n");
                    $$ = makeNode(E_OPERATION, STRING, "=", makeNode(E_VALUE, VARIABLE, ((Data*)$1)->sval), makeNode(E_VALUE, CHAR, ((Data*)$3)->sval));
                }
        |       VAR ASSIGN LIT_STRING MISC_SEMI
                {
                    dprint(" -ASSIGN STRING- (3)\n");
                    $$ = makeNode(E_OPERATION, STRING, "=", makeNode(E_VALUE, VARIABLE, ((Data*)$1)->sval), makeNode(E_VALUE, STRING, ((Data*)$3)->sval));
                }
        |       VAR ASSIGN ARR_LP arraystruct ARR_RP MISC_SEMI
                {
                    dprint(" -ASSIGN ARRAY- (2)\n");
                    $$ = makeNode(E_OPERATION, STRING, "=", makeNode(E_VALUE, VARIABLE, ((Data*)$1)->sval), $4);
                }; //Attenzione!

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


exprlvl_1:      exprlvl_1 logicOperator exprlvl_2 {dprint(" -EXPR LOGIC (1)-\n"); $$ = makeNode(E_OPERATION, STRING, $2, $1, $3);}
        |       exprlvl_2 {$$=$1;};

exprlvl_2:      exprlvl_2 lineOperator exprlvl_3 {dprint(" -EXPR LINE (1)-\n"); $$ = makeNode(E_OPERATION, STRING, $2, $1, $3);}
        |       exprlvl_3 {$$=$1;};

exprlvl_3:      exprlvl_3 pointOperator exprlvl_4 {dprint(" -EXPR POINT (1)-\n"); $$ = makeNode(E_OPERATION, STRING, $2, $1, $3);}
        |       exprlvl_4 {$$=$1;};   

exprlvl_4:      exprlvl_4 potOperator literal {dprint(" -EXPR POT (1)-\n"); $$ = makeNode(E_OPERATION, STRING, $2, $1, $3);}
        |       literal {$$=$1;};


literal:        MISC_LP exprlvl_1 MISC_RP {$$ = $2;}
        |       LOGIC_NOT MISC_LP exprlvl_1 MISC_RP {dprint(" -LIT LOGIC NOT (1)-\n"); $$ = makeNode(E_OPERATION, STRING, "!", $3);}
        |       LIT_BOOL {dprint(" -LIT BOOL (1)-\n"); $$ = makeNode(E_VALUE, BOOL, $1);}
        |       number {dprint(" -LIT NUM (1)-\n"); $$ = makeNode(E_VALUE, ((Data*)$1)->type), getNumVal((Data*)$1);}
        |       VAR {dprint(" -LIT VAR (1)-\n"); $$ = makeNode(E_VALUE, VARIABLE, ((Data*)$1)->sval); }
        |       OP_SUB VAR {dprint(" -LIT NEG VAR (2)-\n"); $$ = makeNode(E_OPERATION, STRING, "-", makeNode(E_VALUE, VARIABLE, ((Data*)$2)->sval)); };

number:         LIT_INT {$$ = $1;}
        |       LIT_FLOAT {$$ = $1;}
        |       LIT_ZERO {$$ = $1;}
        |       OP_SUB LIT_INT {((Data*)$2)->ival = -((Data*)$2)->ival; $$ = $2;}        /* negative number */
        |       OP_SUB LIT_FLOAT {((Data*)$2)->fval = -((Data*)$2)->fval; $$ = $2;};

lineOperator:   OP_ADD {$$ = "+";} 
        |       OP_SUB {$$ = "-";};

pointOperator:  OP_MUL {$$ = "*";}
        |       OP_DIV {$$ = "/";}
        |       OP_MOD {$$ = "%";};

potOperator:    OP_POT {$$ = "^";};

logicOperator:  COMP_EQL {$$ = "==";}
        |       COMP_LT {$$ = "<";}
        |       COMP_LE {$$ = ">=";}
        |       COMP_GT {$$ = ">";}
        |       COMP_GE {$$ = ">=";}

        |       LOGIC_AND {$$ = "&";}
        |       LOGIC_OR {$$ = "|";};

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
        FILE *fh;
        fh = fopen("/home/moritz/flex/TICompiler/src/TestInput", "r");
        yyin = fh;
        dprint("\n\n---NODE CREATION--\n\n");
        yyparse();
        dprint("\n\n---VAR LIST--\n\n");
        printVars();
        dprint("\n\n---SYNTAX TREE--\n\n");
        printProgTree(progRoot);
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
    if(!varRoot)
    {
            varRoot = var;
    }
    else
    {
            Variable* tmp = varRoot;

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
    if(!varRoot)
    {
        free(var);
        yyerror("Fehlermeldung, Var nicht deklariert(in fact, no vars are deklariert)");
        exit(-1);
    }
    else
    {
            Variable* varOld = varRoot;

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
        tmp = varRoot;
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
        tmp = varRoot;
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

//makeNode(type, valType, value, lchild, rchild);       <-- Inner Node with 2 Children
//makeNode(type, valType, value, lchild);               <-- Inner Node with 1 Child
//makeNode(type, valType, value);                       <-- Leaf-Definition

SyntaxNode* makeNode(int nodeType, int valueType, ...){
        va_list args;               // 👈 check it out!
        va_start(args, valueType);
        SyntaxNode* node = (SyntaxNode*) malloc(sizeof(SyntaxNode));

        node->nodeType = nodeType;            // 👈 ENUM -> NodeType
        node->valueType = valueType;
        node->expressionType = 69;

        switch (valueType) {
        case BOOL:
        case INT:
            node->ival = va_arg(args, int);
            break;
        case FLOAT:
            node->fval = (float)va_arg(args, double);
            break;
        case CHAR:
        case STRING:
        case VARIABLE:
            node->sval = va_arg(args, char*);
            break;
        default:
            yyerror("Node ValueType error!");
        }

        SyntaxNode* leftChild = va_arg(args, SyntaxNode*);
        SyntaxNode* rightChild = va_arg(args, SyntaxNode*);

#ifdef IGUANADEBUG
        int children = 0;
#endif

        if(leftChild)   // != NULL
        {
                node-> leftChild = leftChild;
#ifdef IGUANADEBUG
        children++;
#endif
        }
        else
                node-> leftChild = NULL;
        
        if(rightChild)  // != NULL
        {
                node-> rightChild = rightChild;
#ifdef IGUANADEBUG
        children++;
#endif
        }
        else
                node-> rightChild = NULL;

        va_end(args);
#ifdef IGUANADEBUG
        char* type = "Value";
        if(node->nodeType == E_OPERATION)type = node->sval;
        printf("Made node %s with %d childs\n", type, children);
#endif

        return node;
}

float getNumVal(Data* data){
        if(data->type == INT)
        {
                return (float)data->ival;
        }
        else if(data->type == FLOAT)
        {
                return data->fval;
        }
        return 0;
}


void printProgTree(SyntaxNode* prog){
    if(!prog){
        printf("--Empty Node--\n\n");
        return;
    }
    char* next = "null";
    if(prog->leftChild){
        if(prog->leftChild->nodeType == E_OPERATION)next = prog->leftChild->sval;
        else if(prog->leftChild->nodeType == E_VALUE)next = "Value";
    }
    printf("stepping down into: %s\n", next);
    printProgTree(prog->leftChild);
    printf("stepping up to parent\n");

    printf("printing node\n");
    printNode(prog);

    char* rch = "null";
    if(prog->rightChild){
        if(prog->rightChild->nodeType == E_OPERATION)rch = prog->rightChild->sval;
        else if(prog->rightChild->nodeType == E_VALUE)rch = "Value";
    }
    printf("stepping down into rightChild: %s\n", rch);
    printProgTree(prog->rightChild);
    printf("stepping up\n");
}

void printNode(SyntaxNode* node){

    if(node->nodeType == E_OPERATION)
    {
        printf("--Operation--\n");
        printf("valueType(should be 4): %d\n", node->valueType);
        printf("opString: %s\n", node->sval);
    }
    else if(node->nodeType == E_VALUE)
    {
        printf("--Value--\n");
        printf("valueType: %d\n", node->valueType);
    }
    printf("end of node\n");
    printf("\n");
}

void dprint(char* text){
#ifdef IGUANADEBUG
//    printf(text);
#endif
}



