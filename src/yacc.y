%{
        #include <stdio.h>
        #include <string.h>
        #include <stdarg.h>
        #include <stdlib.h>
        #include "thunderstruct.h"

//        #define NODEDEBUG

        extern FILE *yyin;
        int lineno = 1;
        Variable* varRoot = NULL;
        SyntaxNode* progRoot = NULL;
        int countProgTree = 0;

        //Forward-Declaration
        int yylex(void);
        void yyerror(char*);

        Variable* makeVar(int type, char* name);        //create a Variable construct. Used to store in Datastructure
        void insertVar(Variable* var, Flags flags, SyntaxNode* value);     //insert Var into struct "Variable"
        void assignVar(Variable* var, SyntaxNode* value);                  //checks if Var exists for assignment
        void printVars();                               //print all nodes in "Variable" (last action of program, called in main)
        Variable* getVar(char* name);                   //retrieve Var from datastructure for insertion on right hand side of assignment
        SyntaxNode* makeNode(int argCount, int nodeType, int valueType, ...);
        float getNumVal(Data* data);
        void printNode(SyntaxNode* node);
        void printProgTree(SyntaxNode* prog);
        void checkType(Type vType, Type eType);

        //debug
        void nodeDPrint(char* str);

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
%type <content> arrayitem

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
                    nodeDPrint (" -PROG DECLARATION-  (1)\n");
                    progRoot = makeNode(5, E_OPERATION, STRING, "Prog", progRoot, $2);
                    nodeDPrint("\n");
                }
        |       program assignment
                {
                    nodeDPrint (" -PROG ASSIGN-  (1)\n");
                    progRoot= makeNode(5, E_OPERATION, STRING, "Prog", progRoot, $2);
                    Type exprType = ((SyntaxNode*)$2)->rightChild->expressionType;
                    Variable* var = getVar(((SyntaxNode*)$2)->leftChild->sval);
                    checkType(var->type, exprType);
                    assignVar(var, ((SyntaxNode*)$2)->rightChild);
                    nodeDPrint("\n");
                }
        |       program controlBlock
                {
                    nodeDPrint("\n");
                }

        |       program DEBUG MISC_LP LIT_STRING MISC_RP MISC_SEMI { printf("debug: %s \n", ((Data*)$4)->sval);}
        |       {
                    nodeDPrint(" -EMPTY- \n");
                    nodeDPrint("Made the EMPTY Node (1)\n\n");
                    $$ = NULL;
                };

declaration:    type VAR MISC_SEMI
                {
                    nodeDPrint(" -DECL UNDEF- (3)\n");
                    $$ = makeNode(5, E_OPERATION, STRING, "DECL", makeNode(3, E_VALUE, INT, $1), makeNode(3, E_VALUE, VARIABLE, ((Data*)$2)->sval));
                    insertVar(makeVar($1, ((Data*)$2)->sval), E_UNDEF, NULL);
                }
        |       type assignment
                {
                    nodeDPrint(" -DECL ASSIGN- (2)\n");
                    Type exprType = ((SyntaxNode*)$2)->rightChild->expressionType;
                    checkType($1, exprType);
                    $$ = makeNode(5, E_OPERATION, STRING, "DECL", makeNode(3, E_VALUE, INT, $1), $2);
                    insertVar(makeVar($1, ((SyntaxNode*)$2)->leftChild->sval), E_VAR, ((SyntaxNode*)$2)->rightChild);
                }
        |       CONST_DECL type assignment
                {
                    nodeDPrint(" -DECL CONST- (2)\n");
                    Type exprType = ((SyntaxNode*)$3)->rightChild->expressionType;
                    checkType($2, exprType);
                    $$ = makeNode(5, E_OPERATION, STRING, "DECL", makeNode(3, E_VALUE, INT, $2), $3);
                    insertVar(makeVar($2, ((SyntaxNode*)$3)->leftChild->sval), E_CONST, ((SyntaxNode*)$3)->rightChild);
                }
        |       type TYPE_ARRAY assignment
                {
                    nodeDPrint(" -DECL ARRAY- (2)\n");
                    Type exprType = ((SyntaxNode*)$3)->rightChild->expressionType;
                    checkType($1, exprType);
                    $$ = makeNode(5, E_OPERATION, STRING, "DECL", makeNode(3, E_VALUE, INT, $1), $3);
                    insertVar(makeVar($1, ((SyntaxNode*)$3)->leftChild->sval), E_ARR, ((SyntaxNode*)$3)->rightChild);
                };

assignment:     VAR ASSIGN exprlvl_1 MISC_SEMI
                {
                    nodeDPrint(" -ASSIGN EXPR- (2)\n");
                    $$ = makeNode(5, E_OPERATION, STRING, "=", makeNode(3, E_VALUE, VARIABLE, ((Data*)$1)->sval), $3);
                }
        |       VAR ASSIGN LIT_CHAR MISC_SEMI
                {
                    nodeDPrint(" -ASSIGN CHAR- (3)\n");
                    SyntaxNode *charNode = makeNode(3, E_VALUE, CHAR, ((Data*)$3)->sval);
                    charNode->expressionType = CHAR;
                    $$ = makeNode(5, E_OPERATION, STRING, "=", makeNode(3, E_VALUE, VARIABLE, ((Data*)$1)->sval), charNode);
                }
        |       VAR ASSIGN LIT_STRING MISC_SEMI
                {
                    nodeDPrint(" -ASSIGN STRING- (3)\n");
                    SyntaxNode *strNode = makeNode(3, E_VALUE, STRING, ((Data*)$3)->sval);
                    strNode->expressionType = STRING;
                    $$ = makeNode(5, E_OPERATION, STRING, "=", makeNode(3, E_VALUE, VARIABLE, ((Data*)$1)->sval), strNode);
                }
        |       VAR ASSIGN ARR_LP arraystruct ARR_RP MISC_SEMI //TODO VARIABLE STRUCT IMPLEMENTATION && SYNTAX IMPLEMENTATION (++TYPEMATCHING)
                {
                    nodeDPrint(" -ASSIGN ARRAY- (2)\n");
                    $$ = makeNode(5, E_OPERATION, STRING, "=", makeNode(3, E_VALUE, VARIABLE, ((Data*)$1)->sval), $4);
                };

arraystruct:    arrayitem
        |       arrayitem ARR_SEP arraystruct;

arrayitem:      exprlvl_1
        |       LIT_CHAR
        |       LIT_STRING;

type:           TYPE_INT {$$=INT;}
        |       TYPE_FLOAT {$$=FLOAT;}
        |       TYPE_CHAR {$$=CHAR;}
        |       TYPE_STRING {$$=STRING;}
        |       TYPE_BOOL {$$=BOOL;};


exprlvl_1:      exprlvl_1 logicOperator exprlvl_2
                {
                    nodeDPrint(" -EXPR LOGIC (1)-\n");
                    SyntaxNode *node = makeNode(5, E_OPERATION, STRING, $2, $1, $3);
                    node->expressionType = BOOL;
                    $$ = node;
                }
        |       exprlvl_2 {$$=$1;};

exprlvl_2:      exprlvl_2 lineOperator exprlvl_3
                {
                    nodeDPrint(" -EXPR LINE (1)-\n");
                    SyntaxNode *node = makeNode(5, E_OPERATION, STRING, $2, $1, $3);
                    node->expressionType = ( ((SyntaxNode*)$1)->expressionType == FLOAT || ((SyntaxNode*)$3)->expressionType == FLOAT ) ? FLOAT : INT;
                    $$ = node;
                }
        |       exprlvl_3 {$$=$1;};

exprlvl_3:      exprlvl_3 pointOperator exprlvl_4
                {
                    nodeDPrint(" -EXPR POINT (1)-\n");
                    SyntaxNode *node = makeNode(5, E_OPERATION, STRING, $2, $1, $3);
                    node->expressionType = ( ((SyntaxNode*)$1)->expressionType == FLOAT || ((SyntaxNode*)$3)->expressionType == FLOAT ) ? FLOAT : INT;
                    $$ = node;
                }
        |       exprlvl_4 {$$=$1;};   

exprlvl_4:      exprlvl_4 potOperator literal
                {
                    nodeDPrint(" -EXPR POT (1)-\n");
                    SyntaxNode *node = makeNode(5, E_OPERATION, STRING, $2, $1, $3);
                    node->expressionType = ( ((SyntaxNode*)$1)->expressionType == FLOAT || ((SyntaxNode*)$3)->expressionType == FLOAT ) ? FLOAT : INT;
                    $$ = node;
                }
        |       literal {$$=$1;};


literal:        MISC_LP exprlvl_1 MISC_RP {$$ = $2;}
        |       LOGIC_NOT MISC_LP exprlvl_1 MISC_RP
                {
                    nodeDPrint(" -LIT LOGIC NOT (1)-\n");
                    SyntaxNode *node = makeNode(4, E_OPERATION, STRING, "!", $3);
                    node->expressionType = BOOL;
                    $$ = node;
                }
        |       LIT_BOOL
                {
                    nodeDPrint(" -LIT BOOL (1)-\n");
                    SyntaxNode *node = makeNode(3, E_VALUE, BOOL, $1);
                    node->expressionType = BOOL;
                    $$ = node;
                }
        |       number
                {
                    nodeDPrint(" -LIT NUM (1)-\n");
                    Type exprType = ((Data*)$1)->type;
                    SyntaxNode *node = makeNode(3, E_VALUE, ((Data*)$1)->type, getNumVal((Data*)$1));
                    node->expressionType = exprType;
                    $$ = node;
                }
        |       VAR
                {
                    nodeDPrint(" -LIT VAR (1)-\n");
                    Variable* var = getVar(((Data*)$1)->sval);
                    if(var->flags & E_UNDEF){
                        yyerror("ERROR - Use of undefined var in assignment\n");
                        exit(-1);
                    }
                    Type exprType = var->type;
                    SyntaxNode *node = makeNode(3, E_VALUE, VARIABLE, ((Data*)$1)->sval);
                    node->expressionType = exprType;
                    $$ = node;
                }
        |       OP_SUB VAR
                {
                    nodeDPrint(" -LIT NEG VAR (2)-\n");
                    Type exprType = (getVar(((Data*)$2)->sval))->type;
                    SyntaxNode *node = makeNode(4, E_OPERATION, STRING, "-", makeNode(3, E_VALUE, VARIABLE, ((Data*)$2)->sval));
                    node->expressionType = exprType;
                    $$ = node;
                };

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
//        FILE *fh;
//        fh = fopen("/home/moritz/flex/TICompiler/src/input", "r");
//        yyin = fh;
        printf("\n\n---NODE CREATION--\n\n");
        yyparse();
        printf("\n\n---SYNTAX TREE--\n\n");
//        printProgTree(progRoot);
        printf("\n\n---VAR LIST--\n\n");
//        printVars();
	return 0;
}

Variable* makeVar(int varType, char* varName){
    Variable* var = (Variable*) malloc(sizeof(Variable));
    var->type = varType;
    var->name = varName;
    var->next = NULL;
    return var;
}

void insertVar(Variable* var, Flags flags, SyntaxNode* value){
    var->flags = flags;
    var->value = value;
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

void assignVar(Variable* var, SyntaxNode* value){
        if(var->flags & E_CONST){
            yyerror("Fehlermeldung, Neuzuweisung Konstante - pfui");
            exit(-1);
        }
        //TODO was mit Arrays
        var->flags = E_VAR;
        var->value = value;
        return;
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
        yyerror("Fehlermeldung, Var nicht deklariert");
        exit(-1);        
}

//makeNode(argCount, type, valType, value, lchild, rchild);       <-- Inner Node with 2 Children
//makeNode(argCount, type, valType, value, lchild);               <-- Inner Node with 1 Child
//makeNode(argCount, type, valType, value);                       <-- Leaf-Definition


SyntaxNode* makeNode(int argCount, int nodeType, int valueType, ...){
        va_list args;               // 👈 check it out!
        va_start(args, valueType);
        SyntaxNode* node = (SyntaxNode*) malloc(sizeof(SyntaxNode));

        node->nodeType = nodeType;            // 👈 ENUM -> NodeType
        node->valueType = valueType;
        node->expressionType = 1337;

        switch (valueType) {
        case BOOL:
        case INT:
            node->ival = (int)va_arg(args, double);
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
        if(argCount>=4){
                SyntaxNode* leftChild = va_arg(args, SyntaxNode*);
                node-> leftChild = leftChild;
        }else{
                node-> leftChild = NULL;
        }
        
        if(argCount>=5){
                SyntaxNode* rightChild = va_arg(args, SyntaxNode*);
                node-> rightChild = rightChild;
        }else{
                node-> rightChild = NULL;
        }

#ifdef NODEDEBUG
        printf("Made node of type %d with %d children\n", node->nodeType, argCount-3);
#endif
        va_end(args);
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

    countProgTree++;
    if(!prog){
        printf("(%d)--Empty Node--\n\n", countProgTree);
        countProgTree--;
        return;
    }

    if(prog->leftChild){
        if(prog->leftChild->nodeType == E_OPERATION)
        {
            printf("(%d)stepping down into leftChild: %s\n", countProgTree, prog->leftChild->sval);
        }
        else if(prog->leftChild->nodeType == E_VALUE)
        {
            printf("(%d)stepping down into leftChild: Value\n", countProgTree);
        }
        else
        {
            printf("Node Error");
        }
        printProgTree(prog->leftChild);
        printf("(%d)stepping up from left\n", countProgTree);
    }


    printNode(prog);

    if(prog->rightChild){
        if(prog->rightChild->nodeType == E_OPERATION)
        {
            printf("(%d)stepping down into rightChild: %s\n", countProgTree, prog->rightChild->sval);
        }
        else if(prog->rightChild->nodeType == E_VALUE)
        {
            printf("(%d)stepping down into rightChild: Value\n", countProgTree);
        }
        else
        {
            printf("Node Error");
        }
        printProgTree(prog->rightChild);
        printf("(%d)stepping up from right\n", countProgTree);
    }
    countProgTree--;
}

void printNode(SyntaxNode* node){

    printf("printing node\n");
    if(!node)return;
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
        printf("value: ");
        switch(node->valueType){
                case BOOL:
                case INT:
                        printf("%d\n", node->ival);
                        break;
                case FLOAT:
                        printf("%.5f\n", node->fval);
                        break;
                case CHAR:
                case STRING:
                        printf("%s\n", node->sval);
                        break;
        }
    }
    printf("end of node\n");
    printf("\n");
}




void checkType(Type vType, Type eType){
    if(vType == FLOAT){
        if(eType == BOOL || eType == INT || eType == FLOAT)return;
    }
    else if(vType == INT){
        if(eType == BOOL || eType == INT)return;
    }
    else if(vType == BOOL){
        if(eType == BOOL)return;
    }
    else if(vType == STRING){
        if(eType == STRING)return;
    }
    else if(vType == CHAR){
        if(eType == CHAR)return;
    }
    yyerror("ERROR - type mismatch");
    exit(-1);
}


void nodeDPrint(char* str){
#ifdef NODEDEBUG
    printf(str);
#endif
}
