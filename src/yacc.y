%{
        #include <stdio.h>
        #include <string.h>
        #include <stdarg.h>
        #include <stdlib.h>
        #include "thunderstruct.h"

        #define NODEDEBUG


        extern FILE *yyin;
        int lineno = 1;
        int arrSizeTmp = 0;
        Variable* varRoot = NULL;
        SyntaxNode* progRoot = NULL;
        int countProgTree = 0;
        int progLevel = 0;

        //Forward-Declaration
        int yylex(void);
        void yyerror(char*);

        Variable* makeVar(int type, char* name);        //create a Variable construct. Used to store in Datastructure
        void insertVar(Variable* var, Flags flags, SyntaxNode* value);     //insert Var into struct "Variable"
        void printVars();                               //print all nodes in "Variable" (last action of program, called in main)
        Variable* getVar(char* name);                   //retrieve Var from datastructure for insertion on right hand side of assignment
        SyntaxNode* makeNode(int argCount, int nodeType, int valueType, ...);
        void printNode(SyntaxNode* node);
        char* getNodeType(NodeType nodeType);
        char* getValueType(Type type);
        void printProgTree(SyntaxNode* prog);
        void checkType(Type vType, Type eType);
        void checkArrSize(int declSize, int assignSize);
        void assignVar(Variable* var, SyntaxNode* expr);
        void checkArrBeforeAssignment(Variable* var, Data* literal);
        SyntaxNode* castArray(SyntaxNode* node);

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
%token TYPE_VOID

%token SQR_LP
%token SQR_RP

%token ARR_LP
%token ARR_RP
%token ARR_SEP

%token <content> LIT_INT   // int literal 
%token <content> LIT_BOOL  // true, false 
%token <content> LIT_CHAR
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
%type <content> arrAssignment
%type <content> arrIndexAssignment

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
                    nodeDPrint (" -PROG DECLARATION-  (1)\n");
                    progRoot = makeNode(5, E_PROG, STRING, "Prog", progRoot, $2);
                    nodeDPrint("\n");
                }
        |       program assignment      //a = ...
                {
                    nodeDPrint (" -PROG ASSIGN-  (1)\n");
                    progRoot= makeNode(5, E_PROG, STRING, "Prog", progRoot, $2);
                    Type exprType = ((SyntaxNode*)$2)->rightChild->expressionType;
                    
                    if(((SyntaxNode*)$2)->leftChild->valueType == VARIABLE)
                    {
                        Variable* var = getVar(((SyntaxNode*)$2)->leftChild->sval);
                        checkType(var->type, exprType);
                        var->flags = E_VAR;
                    }
                    else
                    {
                        yyerror("Fatal Error in Assignment");
                        exit(-1);
                    }
                    nodeDPrint("\n");
                }
        |       program arrAssignment   //arr = {..}
                {
                    nodeDPrint (" -PROG ASSIGN-  (1)\n");
                    progRoot= makeNode(5, E_PROG, STRING, "Prog", progRoot, $2);
                    Type exprType = ((SyntaxNode*)$2)->rightChild->expressionType;

                    if(((SyntaxNode*)$2)->leftChild->valueType == VARIABLE)
                    {
                        Variable* var = getVar(((SyntaxNode*)$2)->leftChild->sval);
                        checkType(var->type, exprType);
                        var->flags = E_ARR;
                    }
                    else
                    {
                        yyerror("Fatal Error in Assignment");
                        exit(-1);
                    }
                    nodeDPrint("\n");
                }
        |       program arrIndexAssignment      //arr[1] = ...
                {
                    nodeDPrint (" -PROG ASSIGN-  (1)\n");
                    progRoot= makeNode(5, E_PROG, STRING, "Prog", progRoot, $2);
                    Type exprType = ((SyntaxNode*)$2)->rightChild->expressionType;

                    if(((SyntaxNode*)$2)->leftChild->valueType == ARRAY)
                    {
                        Variable* var = getVar(((SyntaxNode*)$2)->leftChild->aval.sval);
                        checkType(var->type, exprType);
                        
                    }
                    else
                    {
                        yyerror("Fatal Error in Assignment");
                        exit(-1);
                    }
                    nodeDPrint("\n");
                }

        |       program controlBlock
                {
                    nodeDPrint("\n");
                }

        |       program type VAR MISC_LP paramlist MISC_RP ARR_LP program ARR_RP
                {
                    nodeDPrint(" -FUNCTION DEFINITION-\n");
                }

        |       program type VAR MISC_LP paramlist MISC_RP MISC_SEMI
                {
                    nodeDPrint(" -FUNCTION FORWARD DECLARATION-\n");
                }

        |       program VAR MISC_LP arglist MISC_RP MISC_SEMI
                {
                    nodeDPrint(" -FUNCTION CALL-\n");
                }

        |       program DEBUG MISC_LP LIT_STRING MISC_RP MISC_SEMI { printf("debug: %s \n", ((Data*)$4)->sval);}

        |       {
                    nodeDPrint(" -EMPTY- \n");
                    nodeDPrint("Made the EMPTY Node (1)\n\n");
                    $$ = NULL;
                };

paramlist:      parameter
        |       parameter ARR_SEP paramlist
        |;

parameter:      type VAR;

arglist:        VAR
        |       VAR ARR_SEP arglist
        |;


declaration:    type VAR MISC_SEMI
                {
                    nodeDPrint(" -DECL UNDEF- (3)\n");
                    $$ = makeNode(5, E_OPERATION, STRING, "DECL", makeNode(3, E_TYPE, INT, $1), makeNode(3, E_VALUE, VARIABLE, ((Data*)$2)->sval));
                    insertVar(makeVar($1, ((Data*)$2)->sval), E_UNDEF, NULL);
                }
        |       type assignment
                {
                    nodeDPrint(" -DECL ASSIGN- (2)\n");
                    Type exprType = ((SyntaxNode*)$2)->rightChild->expressionType;
                    checkType($1, exprType);
                    $$ = makeNode(5, E_OPERATION, STRING, "DECL", makeNode(3, E_TYPE, INT, $1), $2);
                    insertVar(makeVar($1, ((SyntaxNode*)$2)->leftChild->sval), E_VAR, ((SyntaxNode*)$2)->rightChild);
                }
        |       CONST_DECL type assignment
                {
                    nodeDPrint(" -DECL CONST- (2)\n");
                    Type exprType = ((SyntaxNode*)$3)->rightChild->expressionType;
                    checkType($2, exprType);
                    $$ = makeNode(5, E_OPERATION, STRING, "DECL", makeNode(3, E_TYPE, INT, $2), $3);
                    insertVar(makeVar($2, ((SyntaxNode*)$3)->leftChild->sval), E_CONST, ((SyntaxNode*)$3)->rightChild);
                }
        |       type SQR_LP LIT_INT SQR_RP VAR SQR_LP SQR_RP MISC_SEMI
                {
                    nodeDPrint(" -DECL ARRAY UNDEF- (2)\n");
                    $$ = makeNode(5, E_OPERATION, STRING, "DECL", makeNode(3, E_TYPE, INT, $1), makeNode(3, E_VALUE, VARIABLE, ((Data*)$5)->sval));
                    SyntaxNode* node = makeNode(3, E_ARRAY, INT, ((Data*)$3)->ival);
                    insertVar(makeVar($1, ((Data*)$5)->sval), E_ARR|E_UNDEF, node);
                }
        |       type SQR_LP LIT_INT SQR_RP arrAssignment
                {
                    nodeDPrint(" -DECL ARRAY- (2)\n");                    
                    checkArrSize(((Data*)$3)->ival, (((SyntaxNode*)$5)->rightChild->ival)+1);
                    Type exprType = ((SyntaxNode*)$5)->rightChild->expressionType;
                    checkType($1, exprType);
                    $$ = makeNode(5, E_OPERATION, STRING, "DECL", makeNode(3, E_TYPE, INT, $1), $5);
                    insertVar(makeVar($1, ((SyntaxNode*)$5)->leftChild->sval), E_ARR, ((SyntaxNode*)$5)->rightChild);
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
                };

arrAssignment:
                VAR SQR_LP SQR_RP ASSIGN ARR_LP arraystruct ARR_RP MISC_SEMI //arr = {...};
                {
                    nodeDPrint(" -ASSIGN ARRAY- (2)\n");
                    SyntaxNode* node = makeNode(5, E_OPERATION, STRING, "=", makeNode(3, E_VALUE, VARIABLE, ((Data*)$1)->sval), $6);
                    $$ = node;
                    arrSizeTmp = 0;
                }
        |       VAR SQR_LP SQR_RP ASSIGN VAR SQR_LP SQR_RP MISC_SEMI //arr0 = arr1;
                {
                    nodeDPrint(" -ASSIGN ARRAY- (2)\n");
                    Variable* var = getVar(((Data*)$5)->sval);
                    if(!(var->flags & E_ARR)){
                        yyerror("ERROR - assignment of non array var to array var");
                        exit(-1);
                    }
                    SyntaxNode* node = makeNode(5, E_OPERATION, STRING, "=", makeNode(3, E_VALUE, VARIABLE, ((Data*)$1)->sval), $5);
                    $$ = node;
                };

arrIndexAssignment: //arr[3] = ...;
                VAR SQR_LP LIT_INT SQR_RP ASSIGN exprlvl_1 MISC_SEMI
                {
                        nodeDPrint(" -ASSIGN ARRAY BY INDEX EXPR- ()\n");                  
                        checkArrBeforeAssignment(getVar(((Data*)$1)->sval), $3);
                        
                        SyntaxNode *node = makeNode(3, E_VALUE, ARRAY, NULL);
                        node->aval.index = ((Data*)$3)->ival;
                        node->aval.sval = ((Data*)$1)->sval;       
                        
                        $$ = makeNode(5, E_OPERATION, STRING, "=", node, $6);
                }
        |       VAR SQR_LP LIT_INT SQR_RP ASSIGN LIT_CHAR MISC_SEMI
                {
                        nodeDPrint(" -ASSIGN ARRAY BY INDEX CHAR- ()\n");
                        checkArrBeforeAssignment(getVar(((Data*)$1)->sval), $3);
                        
                        SyntaxNode *node = makeNode(3, E_VALUE, ARRAY, NULL);
                        node->aval.index = ((Data*)$3)->ival;
                        node->aval.sval = ((Data*)$1)->sval;
                        
                        SyntaxNode *charNode = makeNode(3, E_VALUE, CHAR, ((Data*)$6)->sval);
                        charNode->expressionType = CHAR;
                        
                        $$ = makeNode(5, E_OPERATION, STRING, "=", node, charNode);
                }
        |       VAR SQR_LP LIT_INT SQR_RP ASSIGN LIT_STRING MISC_SEMI
                {
                        nodeDPrint(" -ASSIGN ARRAY BY INDEX STRING- ()\n");
                        checkArrBeforeAssignment(getVar(((Data*)$1)->sval), $3);
                        
                        SyntaxNode *node = makeNode(3, E_VALUE, ARRAY, NULL);
                        node->aval.index = ((Data*)$3)->ival;
                        node->aval.sval = ((Data*)$1)->sval;

                        SyntaxNode *strNode = makeNode(3, E_VALUE, STRING, ((Data*)$6)->sval);
                        strNode->expressionType = STRING;
                        
                        $$ = makeNode(5, E_OPERATION, STRING, "=", node, strNode);
                };


arraystruct:    arrayitem
        {
            SyntaxNode* node = makeNode(5, E_ARRAY, INT, arrSizeTmp++, NULL, $1);
            node->expressionType = ((SyntaxNode*)$1)->expressionType;
            $$ = node;
        }
|       arrayitem ARR_SEP arraystruct
        {
            SyntaxNode* node = makeNode(5, E_ARRAY, INT, arrSizeTmp++, $3, $1);
            node = castArray(node); //if int|bool and float --> cast all to float
            checkType(((SyntaxNode*)$1)->expressionType, ((SyntaxNode*)$3)->expressionType);
            node->expressionType = ((SyntaxNode*)$1)->expressionType;
            $$ = node;
        };

arrayitem:      exprlvl_1
                {
                    $$ = $1;
                }
        |       LIT_CHAR
                {
                    SyntaxNode* node = makeNode(3, E_VALUE, CHAR, ((Data*)$1)->sval);
                    node->expressionType = CHAR;
                    $$ = node;
                }
        |       LIT_STRING
                {
                    SyntaxNode* node = makeNode(3, E_VALUE, STRING, ((Data*)$1)->sval);
                    node->expressionType = STRING;
                    $$ = node;
                };

type:           TYPE_INT {$$=INT;}
        |       TYPE_FLOAT {$$=FLOAT;}
        |       TYPE_CHAR {$$=CHAR;}
        |       TYPE_STRING {$$=STRING;}
        |       TYPE_BOOL {$$=BOOL;}
        |       TYPE_VOID {$$=VOID;};


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
                    SyntaxNode *node = makeNode(3, E_VALUE, BOOL, ((Data*)$1)->ival);
                    node->expressionType = BOOL;
                    $$ = node;
                }
        |       number
                {
                    nodeDPrint(" -LIT NUM (1)-\n");
                    Type exprType = ((Data*)$1)->type;
                     SyntaxNode *node;
                    if(exprType == INT)
                        node = makeNode(3, E_VALUE, exprType, ((Data*)$1)->ival);
                    else if(exprType == FLOAT)
                        node = makeNode(3, E_VALUE, exprType, ((Data*)$1)->fval);
                    node->expressionType = exprType;
                    $$ = node;
                }
        |       VAR
                {
                    nodeDPrint(" -LIT VAR (1)-\n");
                    Variable* var = getVar(((Data*)$1)->sval);
                    if(var->flags & E_ARR){
                        yyerror("ERROR - assignment of array var to non array var");
                        exit(-1);
                    }
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
                }
        |       VAR SQR_LP LIT_INT SQR_RP
                {
                    nodeDPrint(" -ARR ACCESS (1)-\n");

                    checkArrBeforeAssignment(getVar(((Data*)$1)->sval), $3);

                    Type exprType = getVar(((Data*)$1)->sval)->type;
                    SyntaxNode *node = makeNode(3, E_VALUE, ARRAY, NULL);
                    node->aval.index = ((Data*)$3)->ival;
                    node->aval.sval = ((Data*)$1)->sval;
                    node->expressionType = exprType;
                    $$ = node;
                };

number:         LIT_INT {$$ = $1;}
        |       LIT_FLOAT {$$ = $1;}
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


int main(int argc, char** argv) {
        if(argc == 1 || argc > 4){
            printf("Compiler for IguanaScript\n");
            printf("Anonyme Iguana (2021)\n\n");
            printf("Usage: iguanacompiler file [-v] [-s]\n");
            exit(0);
        }
        FILE *fh;
        fh = fopen(argv[1], "r");
        if(!fh){
            printf("Invalid file!\n");
            exit(-1);
        }
        yyin = fh;
#ifdef NODEDEBUG
        printf("\n\n---NODE CREATION--\n\n");
#endif
        yyparse();
        if(argc == 3){
            if(strcmp(argv[2], "-v") == 0){
                printf("\n\n---VAR LIST--\n\n");
                printVars();
            }
            if(strcmp(argv[2], "-s") == 0){
                printf("\n\n---SYNTAX TREE--\n\n");
                printProgTree(progRoot);
            }
        }
        else if(argc == 4){
            if(strcmp(argv[2], "-v") == 0 || strcmp(argv[3], "-v") == 0 ){
                printf("\n\n---VAR LIST--\n\n");
                printVars();
            }
            if(strcmp(argv[2], "-s") == 0 || strcmp(argv[3], "-s") == 0 ){
                printf("\n\n---SYNTAX TREE--\n\n");
                printProgTree(progRoot);
            }
        }
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
                        yyerror("ERROR - redefinition of var");
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

void printVars(){
        Variable* tmp;
        tmp = varRoot;
        int varNum = 0;
        while(tmp){
                printf("-----------------------------------\n");
                printf("%d Type: %d Name: %s Flags: %d\n", varNum, tmp->type, tmp->name, tmp->flags);
                if(tmp->flags & E_UNDEF)
                    printf("Var has no assigned value\n");
                else{
                    printProgTree(tmp->value);
                }
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
        yyerror("ERROR - use of undeclared var");
        exit(-1);        
}

//makeNode(argCount, type, valType, value, lchild, rchild);       <-- Inner Node with 2 Children
//makeNode(argCount, type, valType, value, lchild);               <-- Inner Node with 1 Child
//makeNode(argCount, type, valType, value);                       <-- Leaf-Definition


SyntaxNode* makeNode(int argCount, int nodeType, int valueType, ...){
        va_list args;               // ???? check it out!
        va_start(args, valueType);
        SyntaxNode* node = (SyntaxNode*) malloc(sizeof(SyntaxNode));

        node->nodeType = nodeType;            // ???? ENUM -> NodeType
        node->valueType = valueType;
        node->expressionType = 1337;

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
        case ARRAY:
            node->sval = va_arg(args, char*);
            break;
        default:
            yyerror("ERROR - Node ValueType error (internal)");
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
        printf("Made node of type %s with %d children\n", getNodeType(node->nodeType), argCount-3);
#endif
        va_end(args);
        return node;
}

void printProgTree(SyntaxNode* prog){

    countProgTree++;

    //If empty
    if(!prog){
        return;
    }

    if(prog->leftChild){
        if(prog->leftChild->nodeType == E_PROG)
        {
            progLevel++;
        }
        printProgTree(prog->leftChild);
        if(prog->nodeType == E_PROG){
                printf("-----------------------------------------\n");
                printf("Program Nr: %d\n", progLevel);
                progLevel--;
        }
    }

    printNode(prog);


    if(prog->rightChild){
        printProgTree(prog->rightChild);
    }
    countProgTree--;
}

void printNode(SyntaxNode* node){


    if(node->nodeType == E_OPERATION)
    {
        printf("--Operation--\n");
        printf("valueType: %s\n", getValueType(node->valueType));
        printf("opString: %s\n", node->sval);
    }
    else if(node->nodeType == E_TYPE){
        printf("--DataType--\n");
        printf("Type: %s\n", getValueType(node->ival));
    }
    else if(node->nodeType == E_ARRAY){
        printf("--ARRAY STEM NODE--\n");
    }
    else if(node->nodeType == E_PROG){
        printf("--PROGRAM--\n");
    }
    else if(node->nodeType == E_VALUE)
    {
        if(node->valueType == ARRAY){
            printf("\n");
            printf("--ARRAY NODE LOOKUP--\n");
            SyntaxNode* arrNode = getVar(node->aval.sval)->value;
            printf("Array: %s\n", node->aval.sval);
            printf("at index: %d\n", node->aval.index);
            printf("\n");
            int tmpIndex = node->aval.index;
            while(tmpIndex--){
                arrNode = arrNode->leftChild;
            }
            printProgTree(arrNode->rightChild);
            printf("--END OF ARRAY LOOKUP--\n");
            printf("\n");
            return;
        }
        printf("--Value--\n");
        printf("valueType: %s\n", getValueType(node->valueType));
        switch(node->valueType){
                case BOOL:
                case INT:
                        printf("value: %d\n", node->ival);
                        break;
                case FLOAT:
                        printf("value: %.5f\n", node->fval);
                        break;
                case CHAR:
                case STRING:
                    printf("value: %s\n", node->sval);
                    break;
                case VARIABLE:
                    printf("name: %s\n", node->sval);
                        break;
                default:
                        printf("\n");
        }
    }
    printf("\n");
}

char* getNodeType(NodeType nodeType){
        switch(nodeType){
                case E_OPERATION:
                        return "E_OPERATION";
                case E_VALUE:
                        return "E_VALUE";
                case E_PROG:
                        return "E_PROG";
                case E_ARRAY:
                        return "E_ARRAY";
                case E_TYPE:
                        return "E_TYPE";
                default:
                        return "UNKNOWN NODE TYPE";
        }
}


char* getValueType(Type type){
        switch(type){
                case BOOL:
                        return "BOOL";
                case INT:
                        return "INT";
                case FLOAT:
                        return "FLOAT";
                case CHAR:
                        return "CHAR";
                case STRING:
                        return "STRING";
                case VARIABLE:
                        return "VARIABLE";
                case ARRAY:
                        return "ARRAY";
                default:
                        return "UNKNOWN TYPE";
        }
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

void checkArrSize(int declSize, int assignSize){
    if(declSize == assignSize)return;
    yyerror("ERROR - array size mismatch");
    exit(-1);
}

/*
void assignVar(Variable* var, SyntaxNode* expr){
    if(var->flags & E_ARR){
        if(expr->rightChild->nodeType == E_ARRAY)
        {
            var->flags = E_ARR;
            var->value = expr->rightChild;
            return;
        }
        else if(expr->rightChild->valueType == VARIABLE){
            Variable* arrVar = getVar(expr->rightChild->sval);
            if(!(arrVar->flags & E_ARR)){
                yyerror("ERROR - can't assign non array variable to array variable");
                exit(-1);
            }
            if(var->value->ival != arrVar->value->ival){
                yyerror("ERROR - can't assign arrays of non matching dimensions");
                exit(-1);
            }
            else{
                var->flags = E_ARR;
                var->value = arrVar->value;
                return;
            }
        }
        else{
            yyerror("ERROR - can't assign non array expression to array variable");
            exit(-1);
        }
    }
    else{
        if(!(expr->rightChild->nodeType == E_ARRAY)){
            if(expr->rightChild->valueType == VARIABLE){
                Variable* arrVar = getVar(expr->rightChild->sval);
                if(arrVar->flags & E_ARR){
                    yyerror("ERROR - can't assign array variable to non array variable");
                    exit(-1);
                }
            }
            var->flags = E_VAR;
            var->value = expr->rightChild;
            return;
        }
        else{
            yyerror("ERROR - can't assign array expression to non array variable");
            exit(-1);
        }
        if(var->flags & E_CONST){
            yyerror("ERROR - can't assign to const var - pfui");
            exit(-1);
        }
    }
}
*/

void checkArrBeforeAssignment(Variable* var, Data* literal){
        if(var->flags & E_UNDEF){
                yyerror("ERROR - Use of undefined var in assignment\n");
                exit(-1);
        }
        if(var->value->nodeType != E_ARRAY){
                yyerror("ERROR - array index access on non array variable\n");
                exit(-1);
        }
        if(literal->ival > var->value->ival){
                yyerror("ERROR - array index out of bounce\n");
                exit(-1);
        }
}

SyntaxNode* castArray(SyntaxNode* node){
        SyntaxNode* root = node;        //save pointer to root

        int leftExprType = node->leftChild->expressionType;
        int rightExprType = node->rightChild->expressionType;
        if(((leftExprType==INT) & (rightExprType==INT)) | ((leftExprType==FLOAT) & (rightExprType==FLOAT)) | ((leftExprType==BOOL) & (rightExprType==BOOL)))
        {
                return node;
        }
        else if((leftExprType == CHAR) | (leftExprType == STRING) | (rightExprType == CHAR) | (rightExprType == STRING))
        {
                return node;
        }
        else if(((leftExprType == BOOL) & (rightExprType == INT)) | ((leftExprType == INT) & (rightExprType == BOOL)))
        {
                //cast to int
                node->rightChild->expressionType = INT;
                do{
                        node->leftChild->expressionType = INT;
                        node = node-> leftChild;
                }while(node->leftChild);
        }
        else
        {
                //cast to float
                node->rightChild->expressionType = FLOAT;
                do{
                        node->leftChild->expressionType = FLOAT;
                        node = node-> leftChild;
                }while(node->leftChild);
        }
        node = root;    //set pointer back to root
        return node;
}


void nodeDPrint(char* str){
#ifdef NODEDEBUG
    printf("%s",str);
#endif
}
