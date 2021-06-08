/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    OP_ADD = 258,
    OP_SUB = 259,
    OP_MUL = 260,
    OP_DIV = 261,
    OP_POT = 262,
    OP_MOD = 263,
    CONST_DECL = 264,
    ASSIGN = 265,
    COMP_EQL = 266,
    COMP_LT = 267,
    COMP_LE = 268,
    COMP_GT = 269,
    COMP_GE = 270,
    LOGIC_AND = 271,
    LOGIC_OR = 272,
    LOGIC_NOT = 273,
    VAR = 274,
    TYPE_INT = 275,
    TYPE_CHAR = 276,
    TYPE_BOOL = 277,
    TYPE_FLOAT = 278,
    TYPE_STRING = 279,
    TYPE_ARRAY = 280,
    ARR_LP = 281,
    ARR_RP = 282,
    ARR_SEP = 283,
    LIT_INT = 284,
    LIT_BOOL = 285,
    LIT_CHAR = 286,
    LIT_ZERO = 287,
    LIT_STRING = 288,
    LIT_FLOAT = 289,
    CTRL_IF = 290,
    CTRL_THEN = 291,
    CTRL_ELSE = 292,
    CTRL_ELIF = 293,
    CTRL_END = 294,
    CTRL_WHILE = 295,
    CTRL_DO = 296,
    MISC_LP = 297,
    MISC_RP = 298,
    MISC_SEMI = 299,
    DEBUG = 300,
    ERROR = 301
  };
#endif
/* Tokens.  */
#define OP_ADD 258
#define OP_SUB 259
#define OP_MUL 260
#define OP_DIV 261
#define OP_POT 262
#define OP_MOD 263
#define CONST_DECL 264
#define ASSIGN 265
#define COMP_EQL 266
#define COMP_LT 267
#define COMP_LE 268
#define COMP_GT 269
#define COMP_GE 270
#define LOGIC_AND 271
#define LOGIC_OR 272
#define LOGIC_NOT 273
#define VAR 274
#define TYPE_INT 275
#define TYPE_CHAR 276
#define TYPE_BOOL 277
#define TYPE_FLOAT 278
#define TYPE_STRING 279
#define TYPE_ARRAY 280
#define ARR_LP 281
#define ARR_RP 282
#define ARR_SEP 283
#define LIT_INT 284
#define LIT_BOOL 285
#define LIT_CHAR 286
#define LIT_ZERO 287
#define LIT_STRING 288
#define LIT_FLOAT 289
#define CTRL_IF 290
#define CTRL_THEN 291
#define CTRL_ELSE 292
#define CTRL_ELIF 293
#define CTRL_END 294
#define CTRL_WHILE 295
#define CTRL_DO 296
#define MISC_LP 297
#define MISC_RP 298
#define MISC_SEMI 299
#define DEBUG 300
#define ERROR 301

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 32 "yacc.y"

        void* content;
        int type;
        char* opString;

#line 155 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
