/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "yacc.y"

        #include <stdio.h>
        #include <string.h>
        #include <stdarg.h>
        #include <stdlib.h>
        #include "thunderstruct.h"

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


#line 100 "y.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
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

#line 250 "y.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */



#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_int8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  2
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   258

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  47
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  21
/* YYNRULES -- Number of rules.  */
#define YYNRULES  64
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  111

#define YYUNDEFTOK  2
#define YYMAXUTOK   301


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   122,   122,   129,   139,   144,   145,   151,   157,   165,
     173,   182,   187,   194,   201,   207,   208,   210,   211,   212,
     214,   215,   216,   217,   218,   221,   228,   230,   237,   239,
     246,   248,   255,   258,   259,   266,   273,   281,   294,   303,
     304,   305,   306,   307,   309,   310,   312,   313,   314,   316,
     318,   319,   320,   321,   322,   324,   325,   329,   330,   332,
     333,   335,   336,   338,   339
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "OP_ADD", "OP_SUB", "OP_MUL", "OP_DIV",
  "OP_POT", "OP_MOD", "CONST_DECL", "ASSIGN", "COMP_EQL", "COMP_LT",
  "COMP_LE", "COMP_GT", "COMP_GE", "LOGIC_AND", "LOGIC_OR", "LOGIC_NOT",
  "VAR", "TYPE_INT", "TYPE_CHAR", "TYPE_BOOL", "TYPE_FLOAT", "TYPE_STRING",
  "TYPE_ARRAY", "ARR_LP", "ARR_RP", "ARR_SEP", "LIT_INT", "LIT_BOOL",
  "LIT_CHAR", "LIT_ZERO", "LIT_STRING", "LIT_FLOAT", "CTRL_IF",
  "CTRL_THEN", "CTRL_ELSE", "CTRL_ELIF", "CTRL_END", "CTRL_WHILE",
  "CTRL_DO", "MISC_LP", "MISC_RP", "MISC_SEMI", "DEBUG", "ERROR",
  "$accept", "program", "declaration", "assignment", "arraystruct",
  "arrayitem", "type", "exprlvl_1", "exprlvl_2", "exprlvl_3", "exprlvl_4",
  "literal", "number", "lineOperator", "pointOperator", "potOperator",
  "logicOperator", "controlBlock", "controlIf", "controlElif",
  "controlWhile", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301
};
# endif

#define YYPACT_NINF (-33)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     -33,     4,   -33,   182,    -2,   -33,   -33,   -33,   -33,   -33,
      70,    70,   -33,   -32,   -33,   -33,   -14,   -33,   -33,   -33,
       0,    34,   -13,    -6,   -33,   -33,   -33,   -33,   -33,    70,
     215,    47,     9,    33,   -33,   -33,   184,   128,    10,    -7,
       0,   -33,   -33,    51,    12,    13,   163,   -33,   -33,   -33,
      70,    18,   -33,   -33,   -33,   -33,   -33,   -33,   -33,   -33,
      70,   -33,   -33,    70,   -33,   -33,   -33,    70,   -33,    70,
     -33,    70,     3,   -33,   -33,   -33,   -33,    21,    26,   229,
     -33,   -33,   -33,   170,   -33,    86,    47,     9,    33,   -33,
      94,   177,    15,    27,    51,   -33,    70,   -30,   -33,   -33,
     -33,   -33,   -33,   222,   -33,   -33,   -33,   121,    86,   -33,
     -33
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       6,     0,     1,     0,     0,    20,    22,    24,    21,    23,
       0,     0,     6,     0,     2,     3,     0,     4,    57,    58,
       0,     0,     0,     0,    37,    39,    35,    41,    40,     0,
       0,    26,    28,    30,    32,    36,     0,     0,     0,     0,
       0,     8,     9,     0,     0,     0,     0,    38,    42,    43,
       0,     0,    50,    51,    52,    53,    54,    55,    56,     6,
       0,    44,    45,     0,    46,    47,    48,     0,    49,     0,
       6,     0,     0,     7,    10,    18,    19,     0,    15,    17,
      12,    13,    11,     0,    33,    62,    25,    27,    29,    31,
       0,     0,     0,     0,     0,    34,     0,     0,    63,    64,
       5,    14,    16,     0,     6,    59,     6,     0,    62,    60,
      61
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -33,   -12,   -33,     2,   -22,   -33,    72,    -9,    17,    16,
       6,    22,   -33,   -33,   -33,   -33,   -33,   -33,   -33,   -18,
     -33
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     1,    14,    15,    77,    78,    16,    79,    31,    32,
      33,    34,    35,    63,    67,    69,    60,    17,    18,    97,
      19
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int8 yytable[] =
{
      37,    30,    36,    21,     2,    39,    47,   104,    21,   105,
      38,    40,    46,     3,    64,    65,    48,    66,    41,     4,
      51,    49,    42,     4,     5,     6,     7,     8,     9,    52,
      53,    54,    55,    56,    57,    58,    50,    73,    22,    10,
      68,    83,    74,    72,    11,    12,    92,    85,    93,    13,
      61,    62,    23,    24,    94,    22,    80,    81,    90,   100,
      43,    84,    91,    25,    26,    44,    27,    45,    28,    23,
      24,   101,   102,    88,    22,    20,    29,    86,     0,    87,
      25,    26,    75,    27,    76,    28,     0,   103,    23,    24,
     110,    89,   107,    29,   108,     3,     0,     0,     0,    25,
      26,     0,    27,     3,    28,     4,     5,     6,     7,     8,
       9,     0,    29,     4,     5,     6,     7,     8,     9,     0,
       0,    10,     0,     0,    96,     0,    11,    12,     0,    10,
       3,    13,     0,    98,    11,    12,     0,     3,     0,    13,
       4,     5,     6,     7,     8,     9,     0,     4,     5,     6,
       7,     8,     9,     0,     0,     0,    10,     0,     0,     0,
     109,    11,    12,    10,     0,     0,    13,     0,    71,    12,
       0,     0,     0,    13,    52,    53,    54,    55,    56,    57,
      58,    52,    53,    54,    55,    56,    57,    58,    52,    53,
      54,    55,    56,    57,    58,    52,    53,    54,    55,    56,
      57,    58,     5,     6,     7,     8,     9,    82,     0,     0,
       0,     0,     0,    95,     0,     0,    99,     0,    70,     0,
       0,     0,     0,     0,     0,    70,    52,    53,    54,    55,
      56,    57,    58,    52,    53,    54,    55,    56,    57,    58,
      52,    53,    54,    55,    56,    57,    58,     0,     0,     0,
       0,    59,     0,     0,     0,     0,     0,     0,   106
};

static const yytype_int8 yycheck[] =
{
      12,    10,    11,    10,     0,    19,    19,    37,    10,    39,
      42,    25,    21,     9,     5,     6,    29,     8,    16,    19,
      29,    34,    20,    19,    20,    21,    22,    23,    24,    11,
      12,    13,    14,    15,    16,    17,    42,    44,     4,    35,
       7,    50,    40,    33,    40,    41,    43,    59,    27,    45,
       3,     4,    18,    19,    28,     4,    44,    44,    70,    44,
      26,    43,    71,    29,    30,    31,    32,    33,    34,    18,
      19,    44,    94,    67,     4,     3,    42,    60,    -1,    63,
      29,    30,    31,    32,    33,    34,    -1,    96,    18,    19,
     108,    69,   104,    42,   106,     9,    -1,    -1,    -1,    29,
      30,    -1,    32,     9,    34,    19,    20,    21,    22,    23,
      24,    -1,    42,    19,    20,    21,    22,    23,    24,    -1,
      -1,    35,    -1,    -1,    38,    -1,    40,    41,    -1,    35,
       9,    45,    -1,    39,    40,    41,    -1,     9,    -1,    45,
      19,    20,    21,    22,    23,    24,    -1,    19,    20,    21,
      22,    23,    24,    -1,    -1,    -1,    35,    -1,    -1,    -1,
      39,    40,    41,    35,    -1,    -1,    45,    -1,    40,    41,
      -1,    -1,    -1,    45,    11,    12,    13,    14,    15,    16,
      17,    11,    12,    13,    14,    15,    16,    17,    11,    12,
      13,    14,    15,    16,    17,    11,    12,    13,    14,    15,
      16,    17,    20,    21,    22,    23,    24,    44,    -1,    -1,
      -1,    -1,    -1,    43,    -1,    -1,    39,    -1,    41,    -1,
      -1,    -1,    -1,    -1,    -1,    41,    11,    12,    13,    14,
      15,    16,    17,    11,    12,    13,    14,    15,    16,    17,
      11,    12,    13,    14,    15,    16,    17,    -1,    -1,    -1,
      -1,    36,    -1,    -1,    -1,    -1,    -1,    -1,    36
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,    48,     0,     9,    19,    20,    21,    22,    23,    24,
      35,    40,    41,    45,    49,    50,    53,    64,    65,    67,
      53,    10,     4,    18,    19,    29,    30,    32,    34,    42,
      54,    55,    56,    57,    58,    59,    54,    48,    42,    19,
      25,    50,    50,    26,    31,    33,    54,    19,    29,    34,
      42,    54,    11,    12,    13,    14,    15,    16,    17,    36,
      63,     3,     4,    60,     5,     6,     8,    61,     7,    62,
      41,    40,    33,    44,    50,    31,    33,    51,    52,    54,
      44,    44,    44,    54,    43,    48,    55,    56,    57,    58,
      48,    54,    43,    27,    28,    43,    38,    66,    39,    39,
      44,    44,    51,    54,    37,    39,    36,    48,    48,    39,
      66
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int8 yyr1[] =
{
       0,    47,    48,    48,    48,    48,    48,    49,    49,    49,
      49,    50,    50,    50,    50,    51,    51,    52,    52,    52,
      53,    53,    53,    53,    53,    54,    54,    55,    55,    56,
      56,    57,    57,    58,    58,    58,    58,    58,    58,    59,
      59,    59,    59,    59,    60,    60,    61,    61,    61,    62,
      63,    63,    63,    63,    63,    63,    63,    64,    64,    65,
      65,    66,    66,    67,    67
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     2,     2,     2,     6,     0,     3,     2,     3,
       3,     4,     4,     4,     6,     1,     3,     1,     1,     1,
       1,     1,     1,     1,     1,     3,     1,     3,     1,     3,
       1,     3,     1,     3,     4,     1,     1,     1,     2,     1,
       1,     1,     2,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     6,
       8,     5,     0,     5,     5
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2:
#line 123 "yacc.y"
                {
//                    char* varName;
                    printf (" -PROG DECLARATION-  (1)\n");
                    progRoot = makeNode(5, E_OPERATION, STRING, "Prog", progRoot, (yyvsp[0].content));
                    printf("\n");
                }
#line 1542 "y.tab.c"
    break;

  case 3:
#line 130 "yacc.y"
                {
                    printf (" -PROG ASSIGN-  (1)\n");
                    progRoot= makeNode(5, E_OPERATION, STRING, "Prog", progRoot, (yyvsp[0].content));
                    Type exprType = ((SyntaxNode*)(yyvsp[0].content))->rightChild->expressionType;
                    Variable* var = getVar(((SyntaxNode*)(yyvsp[0].content))->leftChild->sval);
                    checkType(var->type, exprType);
                    assignVar(var, ((SyntaxNode*)(yyvsp[0].content))->rightChild);
                    printf("\n");
                }
#line 1556 "y.tab.c"
    break;

  case 4:
#line 140 "yacc.y"
                {
                    printf("\n");
                }
#line 1564 "y.tab.c"
    break;

  case 5:
#line 144 "yacc.y"
                                                                   { printf("debug: %s \n", ((Data*)(yyvsp[-2].content))->sval);}
#line 1570 "y.tab.c"
    break;

  case 6:
#line 145 "yacc.y"
                {
                    printf(" -EMPTY- \n");
                    printf("Made the EMPTY Node (1)\n\n");
                    (yyval.content) = NULL;
                }
#line 1580 "y.tab.c"
    break;

  case 7:
#line 152 "yacc.y"
                {
                    printf(" -DECL UNDEF- (3)\n");
                    (yyval.content) = makeNode(5, E_OPERATION, STRING, "DECL", makeNode(3, E_VALUE, INT, (yyvsp[-2].type)), makeNode(3, E_VALUE, VARIABLE, ((Data*)(yyvsp[-1].content))->sval));
                    insertVar(makeVar((yyvsp[-2].type), ((Data*)(yyvsp[-1].content))->sval), E_UNDEF, NULL);
                }
#line 1590 "y.tab.c"
    break;

  case 8:
#line 158 "yacc.y"
                {
                    printf(" -DECL ASSIGN- (2)\n");
                    Type exprType = ((SyntaxNode*)(yyvsp[0].content))->rightChild->expressionType;
                    checkType((yyvsp[-1].type), exprType);
                    (yyval.content) = makeNode(5, E_OPERATION, STRING, "DECL", makeNode(3, E_VALUE, INT, (yyvsp[-1].type)), (yyvsp[0].content));
                    insertVar(makeVar((yyvsp[-1].type), ((SyntaxNode*)(yyvsp[0].content))->leftChild->sval), E_VAR, ((SyntaxNode*)(yyvsp[0].content))->rightChild);
                }
#line 1602 "y.tab.c"
    break;

  case 9:
#line 166 "yacc.y"
                {
                    printf(" -DECL CONST- (2)\n");
                    Type exprType = ((SyntaxNode*)(yyvsp[0].content))->rightChild->expressionType;
                    checkType((yyvsp[-1].type), exprType);
                    (yyval.content) = makeNode(5, E_OPERATION, STRING, "DECL", makeNode(3, E_VALUE, INT, (yyvsp[-1].type)), (yyvsp[0].content));
                    insertVar(makeVar((yyvsp[-1].type), ((SyntaxNode*)(yyvsp[0].content))->leftChild->sval), E_CONST, ((SyntaxNode*)(yyvsp[0].content))->rightChild);
                }
#line 1614 "y.tab.c"
    break;

  case 10:
#line 174 "yacc.y"
                {
                    printf(" -DECL ARRAY- (2)\n");
                    Type exprType = ((SyntaxNode*)(yyvsp[0].content))->rightChild->expressionType;
                    checkType((yyvsp[-2].type), exprType);
                    (yyval.content) = makeNode(5, E_OPERATION, STRING, "DECL", makeNode(3, E_VALUE, INT, (yyvsp[-2].type)), (yyvsp[0].content));
                    insertVar(makeVar((yyvsp[-2].type), ((SyntaxNode*)(yyvsp[0].content))->leftChild->sval), E_ARR, ((SyntaxNode*)(yyvsp[0].content))->rightChild);
                }
#line 1626 "y.tab.c"
    break;

  case 11:
#line 183 "yacc.y"
                {
                    printf(" -ASSIGN EXPR- (2)\n");
                    (yyval.content) = makeNode(5, E_OPERATION, STRING, "=", makeNode(3, E_VALUE, VARIABLE, ((Data*)(yyvsp[-3].content))->sval), (yyvsp[-1].content));
                }
#line 1635 "y.tab.c"
    break;

  case 12:
#line 188 "yacc.y"
                {
                    printf(" -ASSIGN CHAR- (3)\n");
                    SyntaxNode *charNode = makeNode(3, E_VALUE, CHAR, ((Data*)(yyvsp[-1].content))->sval);
                    charNode->expressionType = CHAR;
                    (yyval.content) = makeNode(5, E_OPERATION, STRING, "=", makeNode(3, E_VALUE, VARIABLE, ((Data*)(yyvsp[-3].content))->sval), charNode);
                }
#line 1646 "y.tab.c"
    break;

  case 13:
#line 195 "yacc.y"
                {
                    printf(" -ASSIGN STRING- (3)\n");
                    SyntaxNode *strNode = makeNode(3, E_VALUE, STRING, ((Data*)(yyvsp[-1].content))->sval);
                    strNode->expressionType = STRING;
                    (yyval.content) = makeNode(5, E_OPERATION, STRING, "=", makeNode(3, E_VALUE, VARIABLE, ((Data*)(yyvsp[-3].content))->sval), strNode);
                }
#line 1657 "y.tab.c"
    break;

  case 14:
#line 202 "yacc.y"
                {
                    printf(" -ASSIGN ARRAY- (2)\n");
                    (yyval.content) = makeNode(5, E_OPERATION, STRING, "=", makeNode(3, E_VALUE, VARIABLE, ((Data*)(yyvsp[-5].content))->sval), (yyvsp[-2].content));
                }
#line 1666 "y.tab.c"
    break;

  case 20:
#line 214 "yacc.y"
                         {(yyval.type)=INT;}
#line 1672 "y.tab.c"
    break;

  case 21:
#line 215 "yacc.y"
                           {(yyval.type)=FLOAT;}
#line 1678 "y.tab.c"
    break;

  case 22:
#line 216 "yacc.y"
                          {(yyval.type)=CHAR;}
#line 1684 "y.tab.c"
    break;

  case 23:
#line 217 "yacc.y"
                            {(yyval.type)=STRING;}
#line 1690 "y.tab.c"
    break;

  case 24:
#line 218 "yacc.y"
                          {(yyval.type)=BOOL;}
#line 1696 "y.tab.c"
    break;

  case 25:
#line 222 "yacc.y"
                {
                    printf(" -EXPR LOGIC (1)-\n");
                    SyntaxNode *node = makeNode(5, E_OPERATION, STRING, (yyvsp[-1].opString), (yyvsp[-2].content), (yyvsp[0].content));
                    node->expressionType = BOOL;
                    (yyval.content) = node;
                }
#line 1707 "y.tab.c"
    break;

  case 26:
#line 228 "yacc.y"
                          {(yyval.content)=(yyvsp[0].content);}
#line 1713 "y.tab.c"
    break;

  case 27:
#line 231 "yacc.y"
                {
                    printf(" -EXPR LINE (1)-\n");
                    SyntaxNode *node = makeNode(5, E_OPERATION, STRING, (yyvsp[-1].opString), (yyvsp[-2].content), (yyvsp[0].content));
                    node->expressionType = ( ((SyntaxNode*)(yyvsp[-2].content))->expressionType == FLOAT || ((SyntaxNode*)(yyvsp[0].content))->expressionType == FLOAT ) ? FLOAT : INT;
                    (yyval.content) = node;
                }
#line 1724 "y.tab.c"
    break;

  case 28:
#line 237 "yacc.y"
                          {(yyval.content)=(yyvsp[0].content);}
#line 1730 "y.tab.c"
    break;

  case 29:
#line 240 "yacc.y"
                {
                    printf(" -EXPR POINT (1)-\n");
                    SyntaxNode *node = makeNode(5, E_OPERATION, STRING, (yyvsp[-1].opString), (yyvsp[-2].content), (yyvsp[0].content));
                    node->expressionType = ( ((SyntaxNode*)(yyvsp[-2].content))->expressionType == FLOAT || ((SyntaxNode*)(yyvsp[0].content))->expressionType == FLOAT ) ? FLOAT : INT;
                    (yyval.content) = node;
                }
#line 1741 "y.tab.c"
    break;

  case 30:
#line 246 "yacc.y"
                          {(yyval.content)=(yyvsp[0].content);}
#line 1747 "y.tab.c"
    break;

  case 31:
#line 249 "yacc.y"
                {
                    printf(" -EXPR POT (1)-\n");
                    SyntaxNode *node = makeNode(5, E_OPERATION, STRING, (yyvsp[-1].opString), (yyvsp[-2].content), (yyvsp[0].content));
                    node->expressionType = ( ((SyntaxNode*)(yyvsp[-2].content))->expressionType == FLOAT || ((SyntaxNode*)(yyvsp[0].content))->expressionType == FLOAT ) ? FLOAT : INT;
                    (yyval.content) = node;
                }
#line 1758 "y.tab.c"
    break;

  case 32:
#line 255 "yacc.y"
                        {(yyval.content)=(yyvsp[0].content);}
#line 1764 "y.tab.c"
    break;

  case 33:
#line 258 "yacc.y"
                                          {(yyval.content) = (yyvsp[-1].content);}
#line 1770 "y.tab.c"
    break;

  case 34:
#line 260 "yacc.y"
                {
                    printf(" -LIT LOGIC NOT (1)-\n");
                    SyntaxNode *node = makeNode(4, E_OPERATION, STRING, "!", (yyvsp[-1].content));
                    node->expressionType = BOOL;
                    (yyval.content) = node;
                }
#line 1781 "y.tab.c"
    break;

  case 35:
#line 267 "yacc.y"
                {
                    printf(" -LIT BOOL (1)-\n");
                    SyntaxNode *node = makeNode(3, E_VALUE, BOOL, (yyvsp[0].content));
                    node->expressionType = BOOL;
                    (yyval.content) = node;
                }
#line 1792 "y.tab.c"
    break;

  case 36:
#line 274 "yacc.y"
                {
                    printf(" -LIT NUM (1)-\n");
                    Type exprType = ((Data*)(yyvsp[0].content))->type;
                    SyntaxNode *node = makeNode(3, E_VALUE, ((Data*)(yyvsp[0].content))->type, getNumVal((Data*)(yyvsp[0].content)));
                    node->expressionType = exprType;
                    (yyval.content) = node;
                }
#line 1804 "y.tab.c"
    break;

  case 37:
#line 282 "yacc.y"
                {
                    printf(" -LIT VAR (1)-\n");
                    Variable* var = getVar(((Data*)(yyvsp[0].content))->sval);
                    if(var->flags & E_UNDEF){
                        yyerror("ERROR - Use of undefined var in assignment\n");
                        exit(-1);
                    }
                    Type exprType = var->type;
                    SyntaxNode *node = makeNode(3, E_VALUE, VARIABLE, ((Data*)(yyvsp[0].content))->sval);
                    node->expressionType = exprType;
                    (yyval.content) = node;
                }
#line 1821 "y.tab.c"
    break;

  case 38:
#line 295 "yacc.y"
                {
                    printf(" -LIT NEG VAR (2)-\n");
                    Type exprType = (getVar(((Data*)(yyvsp[0].content))->sval))->type;
                    SyntaxNode *node = makeNode(4, E_OPERATION, STRING, "-", makeNode(3, E_VALUE, VARIABLE, ((Data*)(yyvsp[0].content))->sval));
                    node->expressionType = exprType;
                    (yyval.content) = node;
                }
#line 1833 "y.tab.c"
    break;

  case 39:
#line 303 "yacc.y"
                        {(yyval.content) = (yyvsp[0].content);}
#line 1839 "y.tab.c"
    break;

  case 40:
#line 304 "yacc.y"
                          {(yyval.content) = (yyvsp[0].content);}
#line 1845 "y.tab.c"
    break;

  case 41:
#line 305 "yacc.y"
                         {(yyval.content) = (yyvsp[0].content);}
#line 1851 "y.tab.c"
    break;

  case 42:
#line 306 "yacc.y"
                               {((Data*)(yyvsp[0].content))->ival = -((Data*)(yyvsp[0].content))->ival; (yyval.content) = (yyvsp[0].content);}
#line 1857 "y.tab.c"
    break;

  case 43:
#line 307 "yacc.y"
                                 {((Data*)(yyvsp[0].content))->fval = -((Data*)(yyvsp[0].content))->fval; (yyval.content) = (yyvsp[0].content);}
#line 1863 "y.tab.c"
    break;

  case 44:
#line 309 "yacc.y"
                       {(yyval.opString) = "+";}
#line 1869 "y.tab.c"
    break;

  case 45:
#line 310 "yacc.y"
                       {(yyval.opString) = "-";}
#line 1875 "y.tab.c"
    break;

  case 46:
#line 312 "yacc.y"
                       {(yyval.opString) = "*";}
#line 1881 "y.tab.c"
    break;

  case 47:
#line 313 "yacc.y"
                       {(yyval.opString) = "/";}
#line 1887 "y.tab.c"
    break;

  case 48:
#line 314 "yacc.y"
                       {(yyval.opString) = "%";}
#line 1893 "y.tab.c"
    break;

  case 49:
#line 316 "yacc.y"
                       {(yyval.opString) = "^";}
#line 1899 "y.tab.c"
    break;

  case 50:
#line 318 "yacc.y"
                         {(yyval.opString) = "==";}
#line 1905 "y.tab.c"
    break;

  case 51:
#line 319 "yacc.y"
                        {(yyval.opString) = "<";}
#line 1911 "y.tab.c"
    break;

  case 52:
#line 320 "yacc.y"
                        {(yyval.opString) = ">=";}
#line 1917 "y.tab.c"
    break;

  case 53:
#line 321 "yacc.y"
                        {(yyval.opString) = ">";}
#line 1923 "y.tab.c"
    break;

  case 54:
#line 322 "yacc.y"
                        {(yyval.opString) = ">=";}
#line 1929 "y.tab.c"
    break;

  case 55:
#line 324 "yacc.y"
                          {(yyval.opString) = "&";}
#line 1935 "y.tab.c"
    break;

  case 56:
#line 325 "yacc.y"
                         {(yyval.opString) = "|";}
#line 1941 "y.tab.c"
    break;


#line 1945 "y.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 342 "yacc.y"


void yyerror (char *s) { fprintf(stderr, "Line %d: %s\n", lineno, s); }

int main(void) { 
//        FILE *fh;
//        fh = fopen("/home/moritz/flex/TICompiler/src/input", "r");
//        yyin = fh;
        printf("\n\n---NODE CREATION--\n\n");
        yyparse();
        printf("\n\n---SYNTAX TREE--\n\n");
        printProgTree(progRoot);
        printf("\n\n---VAR LIST--\n\n");
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

        printf("Made node of type %d with %d children\n", node->nodeType, argCount-3);
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
        switch(node->valueType){
                case BOOL:
                case INT:
                        printf("%d\n", node->ival);
                        break;
                case FLOAT:
                        printf("%.5f\n", node->fval);
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



