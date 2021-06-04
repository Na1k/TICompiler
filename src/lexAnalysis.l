%option noyywrap
%{
	#include <stdio.h>
	#include "y.tab.h"
        #include "thunderstruct.h"

        /*
         * TODO Create dictionary for Variable name & content transfer to yacc
         */
        extern int lineno;

        //Forward-Declaration
        Data* createFloatLiteral(int type, float val);
        Data* createIntLiteral(int type, int val);
        Data* createStringLiteral(int type, char* val);
%}


		
%%

";"			return MISC_SEMI;
"int"			return TYPE_INT;
"char"                  return TYPE_CHAR;
"bool"                  return TYPE_BOOL;
"float"                 return TYPE_FLOAT;
"string"                return TYPE_STRING;
"[]"       return TYPE_ARRAY;

("const"|"CONST")       return CONST_DECL;

("if"|"IF")		return CTRL_IF;
("else"|"ELSE")		return CTRL_ELSE;
("elif"|"ELIF")         return CTRL_ELIF;
("then"|"THEN")         return CTRL_THEN;
("end"|"END")           return CTRL_END;
("while"|"WHILE")       return CTRL_WHILE;
("do"|"DO")             return CTRL_DO;

"+"                     return OP_ADD;
"-"                     return OP_SUB;
"*"                     return OP_MUL;
"/"                     return OP_DIV;
"^"                     return OP_POT;
"%"                     return OP_MOD;

"="                     return ASSIGN;

"=="                    return COMP_EQL;
"<"                     return COMP_LT;
"<="                    return COMP_LE;
">"                     return COMP_GT;
">="                    return COMP_GE;

"&"                     return LOGIC_AND;
"|"                     return LOGIC_OR;
"!"                     return LOGIC_NOT;

 /* XOR */

0			{yylval.content = (void*)createIntLiteral(INT,0); return LIT_ZERO;}
[1-9][0-9]*		{yylval.content = (void*)createIntLiteral(INT,atoi(yytext)); return LIT_INT;}
"'"[a-zA-Z0-9_ ]?"'"    {yylval.content = (void*)createStringLiteral(CHAR,strdup(yytext)); return LIT_CHAR;}
("TRUE"|"true")         {yylval.content = (void*)createIntLiteral(BOOL,1); return LIT_BOOL;}
("FALSE"|"false")       {yylval.content = (void*)createIntLiteral(BOOL,0); return LIT_BOOL;}
([1-9][0-9]*|0)\.[0-9]* {yylval.content = (void*)createFloatLiteral(FLOAT,atof(yytext)); return LIT_FLOAT;}
"\"".*"\""              {yylval.content = (void*)createStringLiteral(STRING,strdup(yytext)); return LIT_STRING;}

"{"                     return ARR_LP;
"}"                     return ARR_RP;
","                     return ARR_SEP;

[a-zA-Z_][a-zA-Z0-9_-]*	{yylval.content = (void*)createStringLiteral(-1,strdup(yytext)); return VAR;}
			
"("			return MISC_LP;
")"			return MISC_RP;

\n			{
				lineno++;
			}
[ \t]			;
"//".*\n                { lineno++; printf("COMMENT\n");}         

"$debug"                return DEBUG;  

.			{
                                return ERROR;
                        }

%%

Data* createIntLiteral(int type, int val){
        Data* litData = (Data*)malloc(sizeof(Data));
        litData->type = type;
        litData->ival = val;
        return litData;
} 

Data* createFloatLiteral(int type, float val){
        Data* litData = (Data*)malloc(sizeof(Data));
        litData->type = type;
        litData->fval = val;
        return litData;
} 

Data* createStringLiteral(int type, char* val){
        Data* litData = (Data*)malloc(sizeof(Data));
        litData->type = type;
        litData->sval = val;
        return litData;
}
