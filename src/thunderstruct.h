#ifndef THUNDERSTRUCT_H
#define THUNDERSTRUCT_H

typedef enum Type {
        INT = 0,
        CHAR,
        BOOL,
        FLOAT,
        STRING,
        VARIABLE,
        ARRAY
} Type;

typedef enum Flags {
        E_CONST = 0x01,         //0001
        E_VAR = 0x02,           //0010
        E_ARR = 0x04,           //0100
        E_UNDEF = 0x08          //1000
} Flags;

typedef enum NodeType {
        E_OPERATION = 0,
        E_VALUE,
        E_PROG,
        E_ARRAY
} NodeType;

typedef struct SyntaxNode {
        int nodeType;               //identifiziert die node selbst (eg Int/eqlvl1 etc...)
        int valueType;
        Type expressionType;
        union
        {
                int ival;
                float fval;
                char *sval;
                struct
                {
                    int index;
                    char *sval;
                } aval;
        };
        struct SyntaxNode* leftChild;
        struct SyntaxNode* rightChild;
} SyntaxNode;

typedef struct NodeQueue {
        SyntaxNode* node;
        struct NodeQueue* next;
} NodeQueue;

typedef struct Variable {
        char* name;
        Type type;
        Flags flags;
        SyntaxNode* value;              //zeigt auf SyntaxNode
        struct Variable* next;
} Variable;

typedef struct Data
{
        int type;
        union
        {
                int ival;
                float fval;
                char *sval;
        };
} Data;

#endif //THUNDERSTRUCT_H
