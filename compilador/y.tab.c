/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
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
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "parser.y"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;


#line 83 "y.tab.c"

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

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    ID = 258,                      /* ID  */
    NUMBER = 259,                  /* NUMBER  */
    TYPE = 260,                    /* TYPE  */
    WHILE = 261,                   /* WHILE  */
    FOR = 262,                     /* FOR  */
    IF = 263,                      /* IF  */
    ELSE = 264,                    /* ELSE  */
    CONST = 265,                   /* CONST  */
    FINAL = 266,                   /* FINAL  */
    ENUM = 267,                    /* ENUM  */
    MAIN = 268,                    /* MAIN  */
    VOID = 269,                    /* VOID  */
    EXCEPTION = 270,               /* EXCEPTION  */
    THROWS = 271,                  /* THROWS  */
    TRY = 272,                     /* TRY  */
    CATCH = 273,                   /* CATCH  */
    FINALLY = 274,                 /* FINALLY  */
    FUNCTION = 275,                /* FUNCTION  */
    SWITCH = 276,                  /* SWITCH  */
    BREAK = 277,                   /* BREAK  */
    CASE = 278,                    /* CASE  */
    CONTINUE = 279,                /* CONTINUE  */
    RETURN = 280,                  /* RETURN  */
    PRINT = 281,                   /* PRINT  */
    PRINTLN = 282,                 /* PRINTLN  */
    SCANF = 283,                   /* SCANF  */
    STRUCT = 284,                  /* STRUCT  */
    MALLOC = 285,                  /* MALLOC  */
    OPENFILE = 286,                /* OPENFILE  */
    READLINE = 287,                /* READLINE  */
    WRITEFILE = 288,               /* WRITEFILE  */
    CLOSEFILE = 289,               /* CLOSEFILE  */
    FREE = 290,                    /* FREE  */
    SIZEOF = 291,                  /* SIZEOF  */
    CONCAT = 292,                  /* CONCAT  */
    LENGHT = 293,                  /* LENGHT  */
    SPLIT = 294,                   /* SPLIT  */
    INCLUDES = 295,                /* INCLUDES  */
    REPLACE = 296,                 /* REPLACE  */
    PUSH = 297,                    /* PUSH  */
    POP = 298,                     /* POP  */
    INDEXOF = 299,                 /* INDEXOF  */
    REVERSE = 300,                 /* REVERSE  */
    SLICE = 301,                   /* SLICE  */
    AND = 302,                     /* AND  */
    OR = 303,                      /* OR  */
    SINGLELINECOMMENT = 304,       /* SINGLELINECOMMENT  */
    LESSTHENEQ = 305,              /* LESSTHENEQ  */
    MORETHENEQ = 306,              /* MORETHENEQ  */
    ISEQUAL = 307,                 /* ISEQUAL  */
    ISDIFFERENT = 308,             /* ISDIFFERENT  */
    ANDCIRCUIT = 309,              /* ANDCIRCUIT  */
    ORCIRCUIT = 310,               /* ORCIRCUIT  */
    NUMBERFLOAT = 311,             /* NUMBERFLOAT  */
    PV = 312,                      /* PV  */
    TRUE = 313,                    /* TRUE  */
    FALSE = 314,                   /* FALSE  */
    DECREMENT = 315,               /* DECREMENT  */
    INCREMENT = 316,               /* INCREMENT  */
    MOREISEQUAL = 317,             /* MOREISEQUAL  */
    LESSISEQUAL = 318,             /* LESSISEQUAL  */
    EQUAL = 319                    /* EQUAL  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define ID 258
#define NUMBER 259
#define TYPE 260
#define WHILE 261
#define FOR 262
#define IF 263
#define ELSE 264
#define CONST 265
#define FINAL 266
#define ENUM 267
#define MAIN 268
#define VOID 269
#define EXCEPTION 270
#define THROWS 271
#define TRY 272
#define CATCH 273
#define FINALLY 274
#define FUNCTION 275
#define SWITCH 276
#define BREAK 277
#define CASE 278
#define CONTINUE 279
#define RETURN 280
#define PRINT 281
#define PRINTLN 282
#define SCANF 283
#define STRUCT 284
#define MALLOC 285
#define OPENFILE 286
#define READLINE 287
#define WRITEFILE 288
#define CLOSEFILE 289
#define FREE 290
#define SIZEOF 291
#define CONCAT 292
#define LENGHT 293
#define SPLIT 294
#define INCLUDES 295
#define REPLACE 296
#define PUSH 297
#define POP 298
#define INDEXOF 299
#define REVERSE 300
#define SLICE 301
#define AND 302
#define OR 303
#define SINGLELINECOMMENT 304
#define LESSTHENEQ 305
#define MORETHENEQ 306
#define ISEQUAL 307
#define ISDIFFERENT 308
#define ANDCIRCUIT 309
#define ORCIRCUIT 310
#define NUMBERFLOAT 311
#define PV 312
#define TRUE 313
#define FALSE 314
#define DECREMENT 315
#define INCREMENT 316
#define MOREISEQUAL 317
#define LESSISEQUAL 318
#define EQUAL 319

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 13 "parser.y"

	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
	

#line 271 "y.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_ID = 3,                         /* ID  */
  YYSYMBOL_NUMBER = 4,                     /* NUMBER  */
  YYSYMBOL_TYPE = 5,                       /* TYPE  */
  YYSYMBOL_WHILE = 6,                      /* WHILE  */
  YYSYMBOL_FOR = 7,                        /* FOR  */
  YYSYMBOL_IF = 8,                         /* IF  */
  YYSYMBOL_ELSE = 9,                       /* ELSE  */
  YYSYMBOL_CONST = 10,                     /* CONST  */
  YYSYMBOL_FINAL = 11,                     /* FINAL  */
  YYSYMBOL_ENUM = 12,                      /* ENUM  */
  YYSYMBOL_MAIN = 13,                      /* MAIN  */
  YYSYMBOL_VOID = 14,                      /* VOID  */
  YYSYMBOL_EXCEPTION = 15,                 /* EXCEPTION  */
  YYSYMBOL_THROWS = 16,                    /* THROWS  */
  YYSYMBOL_TRY = 17,                       /* TRY  */
  YYSYMBOL_CATCH = 18,                     /* CATCH  */
  YYSYMBOL_FINALLY = 19,                   /* FINALLY  */
  YYSYMBOL_FUNCTION = 20,                  /* FUNCTION  */
  YYSYMBOL_SWITCH = 21,                    /* SWITCH  */
  YYSYMBOL_BREAK = 22,                     /* BREAK  */
  YYSYMBOL_CASE = 23,                      /* CASE  */
  YYSYMBOL_CONTINUE = 24,                  /* CONTINUE  */
  YYSYMBOL_RETURN = 25,                    /* RETURN  */
  YYSYMBOL_PRINT = 26,                     /* PRINT  */
  YYSYMBOL_PRINTLN = 27,                   /* PRINTLN  */
  YYSYMBOL_SCANF = 28,                     /* SCANF  */
  YYSYMBOL_STRUCT = 29,                    /* STRUCT  */
  YYSYMBOL_MALLOC = 30,                    /* MALLOC  */
  YYSYMBOL_OPENFILE = 31,                  /* OPENFILE  */
  YYSYMBOL_READLINE = 32,                  /* READLINE  */
  YYSYMBOL_WRITEFILE = 33,                 /* WRITEFILE  */
  YYSYMBOL_CLOSEFILE = 34,                 /* CLOSEFILE  */
  YYSYMBOL_FREE = 35,                      /* FREE  */
  YYSYMBOL_SIZEOF = 36,                    /* SIZEOF  */
  YYSYMBOL_CONCAT = 37,                    /* CONCAT  */
  YYSYMBOL_LENGHT = 38,                    /* LENGHT  */
  YYSYMBOL_SPLIT = 39,                     /* SPLIT  */
  YYSYMBOL_INCLUDES = 40,                  /* INCLUDES  */
  YYSYMBOL_REPLACE = 41,                   /* REPLACE  */
  YYSYMBOL_PUSH = 42,                      /* PUSH  */
  YYSYMBOL_POP = 43,                       /* POP  */
  YYSYMBOL_INDEXOF = 44,                   /* INDEXOF  */
  YYSYMBOL_REVERSE = 45,                   /* REVERSE  */
  YYSYMBOL_SLICE = 46,                     /* SLICE  */
  YYSYMBOL_AND = 47,                       /* AND  */
  YYSYMBOL_OR = 48,                        /* OR  */
  YYSYMBOL_SINGLELINECOMMENT = 49,         /* SINGLELINECOMMENT  */
  YYSYMBOL_LESSTHENEQ = 50,                /* LESSTHENEQ  */
  YYSYMBOL_MORETHENEQ = 51,                /* MORETHENEQ  */
  YYSYMBOL_ISEQUAL = 52,                   /* ISEQUAL  */
  YYSYMBOL_ISDIFFERENT = 53,               /* ISDIFFERENT  */
  YYSYMBOL_ANDCIRCUIT = 54,                /* ANDCIRCUIT  */
  YYSYMBOL_ORCIRCUIT = 55,                 /* ORCIRCUIT  */
  YYSYMBOL_NUMBERFLOAT = 56,               /* NUMBERFLOAT  */
  YYSYMBOL_PV = 57,                        /* PV  */
  YYSYMBOL_TRUE = 58,                      /* TRUE  */
  YYSYMBOL_FALSE = 59,                     /* FALSE  */
  YYSYMBOL_DECREMENT = 60,                 /* DECREMENT  */
  YYSYMBOL_INCREMENT = 61,                 /* INCREMENT  */
  YYSYMBOL_MOREISEQUAL = 62,               /* MOREISEQUAL  */
  YYSYMBOL_LESSISEQUAL = 63,               /* LESSISEQUAL  */
  YYSYMBOL_EQUAL = 64,                     /* EQUAL  */
  YYSYMBOL_65_ = 65,                       /* '('  */
  YYSYMBOL_66_ = 66,                       /* ')'  */
  YYSYMBOL_67_ = 67,                       /* '{'  */
  YYSYMBOL_68_ = 68,                       /* '}'  */
  YYSYMBOL_69_ = 69,                       /* ','  */
  YYSYMBOL_70_ = 70,                       /* '='  */
  YYSYMBOL_71_ = 71,                       /* '+'  */
  YYSYMBOL_72_ = 72,                       /* '-'  */
  YYSYMBOL_73_ = 73,                       /* '*'  */
  YYSYMBOL_74_ = 74,                       /* '/'  */
  YYSYMBOL_YYACCEPT = 75,                  /* $accept  */
  YYSYMBOL_prog = 76,                      /* prog  */
  YYSYMBOL_main = 77,                      /* main  */
  YYSYMBOL_args = 78,                      /* args  */
  YYSYMBOL_subprogs = 79,                  /* subprogs  */
  YYSYMBOL_subprog = 80,                   /* subprog  */
  YYSYMBOL_decl_funcao = 81,               /* decl_funcao  */
  YYSYMBOL_decl_procedimento = 82,         /* decl_procedimento  */
  YYSYMBOL_bloco = 83,                     /* bloco  */
  YYSYMBOL_comando = 84,                   /* comando  */
  YYSYMBOL_retorno = 85,                   /* retorno  */
  YYSYMBOL_condicional = 86,               /* condicional  */
  YYSYMBOL_decl_vars = 87,                 /* decl_vars  */
  YYSYMBOL_decl_variavel = 88,             /* decl_variavel  */
  YYSYMBOL_expressao = 89,                 /* expressao  */
  YYSYMBOL_expre_arit = 90,                /* expre_arit  */
  YYSYMBOL_ops = 91,                       /* ops  */
  YYSYMBOL_termo = 92,                     /* termo  */
  YYSYMBOL_fator = 93                      /* fator  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




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

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
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
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
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

#if !defined yyoverflow

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
#endif /* !defined yyoverflow */

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
#define YYFINAL  14
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   131

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  75
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  19
/* YYNRULES -- Number of rules.  */
#define YYNRULES  47
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  127

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   319


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      65,    66,    73,    71,    69,    72,     2,    74,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    70,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    67,     2,    68,     2,     2,     2,     2,
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
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int8 yyrline[] =
{
       0,    35,    35,    38,    41,    42,    43,    46,    47,    50,
      51,    54,    57,    59,    60,    61,    64,    65,    68,    69,
      72,    73,    74,    77,    78,    81,    82,    83,    84,    85,
      86,    87,    88,    89,    92,    95,    96,    97,    98,    99,
     102,   103,   106,   107,   108,   111,   112,   113
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if YYDEBUG || 0
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "ID", "NUMBER", "TYPE",
  "WHILE", "FOR", "IF", "ELSE", "CONST", "FINAL", "ENUM", "MAIN", "VOID",
  "EXCEPTION", "THROWS", "TRY", "CATCH", "FINALLY", "FUNCTION", "SWITCH",
  "BREAK", "CASE", "CONTINUE", "RETURN", "PRINT", "PRINTLN", "SCANF",
  "STRUCT", "MALLOC", "OPENFILE", "READLINE", "WRITEFILE", "CLOSEFILE",
  "FREE", "SIZEOF", "CONCAT", "LENGHT", "SPLIT", "INCLUDES", "REPLACE",
  "PUSH", "POP", "INDEXOF", "REVERSE", "SLICE", "AND", "OR",
  "SINGLELINECOMMENT", "LESSTHENEQ", "MORETHENEQ", "ISEQUAL",
  "ISDIFFERENT", "ANDCIRCUIT", "ORCIRCUIT", "NUMBERFLOAT", "PV", "TRUE",
  "FALSE", "DECREMENT", "INCREMENT", "MOREISEQUAL", "LESSISEQUAL", "EQUAL",
  "'('", "')'", "'{'", "'}'", "','", "'='", "'+'", "'-'", "'*'", "'/'",
  "$accept", "prog", "main", "args", "subprogs", "subprog", "decl_funcao",
  "decl_procedimento", "bloco", "comando", "retorno", "condicional",
  "decl_vars", "decl_variavel", "expressao", "expre_arit", "ops", "termo",
  "fator", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-81)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int8 yypact[] =
{
      67,   -43,    15,    32,    38,    55,    42,    67,     2,     2,
       2,   -11,    70,    73,   -81,    45,     7,   -81,   -81,   -81,
     -81,   -81,     2,    22,   -56,     4,   -35,   -81,    23,    24,
     -81,     2,     2,     2,    12,    14,    20,    83,    84,   -81,
       7,   -81,   -81,    27,   -81,     4,     4,   -20,     4,     4,
     -81,   -81,   -81,    31,    34,    35,     2,     2,    89,    30,
      33,   -81,   -81,   -20,   -20,   -81,   -81,   -81,   -81,   -81,
      39,    40,    86,    36,    89,    89,   -81,   -81,    -3,    37,
      41,    43,    89,   -81,    44,    46,    47,   -81,   -81,    25,
      25,    50,     0,    48,    25,   -81,   -81,    25,    49,     2,
     -81,    51,   -81,   -81,   -81,   -81,    52,   -81,    53,    25,
      54,    90,     1,    56,    25,     2,    57,    58,   -81,    59,
      25,    60,    91,    62,    25,    63,   -81
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,     0,     0,     0,     0,     0,     0,    23,     0,     0,
       0,     0,     0,     0,     1,     0,     7,    24,    45,    46,
      41,    40,     0,     0,    34,     0,    39,    44,     0,     0,
      33,     0,     0,     0,     0,     0,     0,     0,     0,     2,
       7,     9,    10,     0,    27,     0,     0,    37,     0,     0,
      38,    28,    30,     0,     0,     0,     0,     0,     4,     0,
       0,     8,    47,    35,    36,    42,    43,    26,    29,    25,
       0,     0,     0,     0,     4,     4,    31,    32,     4,     0,
       0,     0,     4,     5,     0,     0,     0,     6,     3,    13,
      13,     0,     0,     0,    13,    17,    16,    13,     0,     0,
      18,     0,    11,    15,    14,    12,     0,    19,     0,    13,
       0,    20,     0,     0,    13,     0,     0,     0,    21,     0,
      13,     0,     0,     0,    13,     0,    22
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -81,   -81,   -81,   -33,    61,   -81,   -81,   -81,   -80,   -81,
     -81,   -81,    96,    64,    -9,   -81,    79,   -14,    26
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
       0,     5,    16,    73,    39,    40,    41,    42,    93,    94,
      95,    96,     6,    97,    23,    24,    25,    26,    27
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int8 yytable[] =
{
      28,    29,    72,    18,    19,    18,    19,    18,    19,   113,
      98,    47,    37,    43,   103,    45,    46,   104,    11,     8,
       9,    38,    53,    54,    55,    20,    21,    10,     1,   110,
       2,    63,    64,    91,   116,     3,     4,    12,    48,    49,
     121,    80,    81,    13,   125,    83,    30,    70,    71,    87,
      92,    31,    32,    48,    49,    14,    15,   100,    36,    33,
      20,    21,    20,    21,     7,    22,    82,    22,   114,    22,
       1,     7,     2,    34,    65,    66,    35,     3,     4,    44,
      51,    52,    56,   101,    57,    58,    59,    60,    67,    78,
     106,    68,    69,    62,    72,    74,    76,    77,    75,   112,
     123,    61,    79,    17,    84,    50,   117,    85,   107,    86,
       0,     0,    88,    89,    90,    99,   102,   105,   108,     0,
     109,   115,   111,     0,   119,   118,   120,     0,   122,   124,
       0,   126
};

static const yytype_int8 yycheck[] =
{
       9,    10,     5,     3,     4,     3,     4,     3,     4,     8,
      90,    25,     5,    22,    94,    71,    72,    97,     3,    62,
      63,    14,    31,    32,    33,    60,    61,    70,     3,   109,
       5,    45,    46,     8,   114,    10,    11,     5,    73,    74,
     120,    74,    75,     5,   124,    78,    57,    56,    57,    82,
      25,    62,    63,    73,    74,     0,    14,    57,    13,    70,
      60,    61,    60,    61,     0,    65,    69,    65,    67,    65,
       3,     7,     5,     3,    48,    49,     3,    10,    11,    57,
      57,    57,    70,    92,    70,    65,     3,     3,    57,     3,
      99,    57,    57,    66,     5,    65,    57,    57,    65,     9,
       9,    40,    66,     7,    67,    26,   115,    66,    57,    66,
      -1,    -1,    68,    67,    67,    65,    68,    68,    66,    -1,
      67,    65,    68,    -1,    66,    68,    67,    -1,    68,    67,
      -1,    68
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,     3,     5,    10,    11,    76,    87,    88,    62,    63,
      70,     3,     5,     5,     0,    14,    77,    87,     3,     4,
      60,    61,    65,    89,    90,    91,    92,    93,    89,    89,
      57,    62,    63,    70,     3,     3,    13,     5,    14,    79,
      80,    81,    82,    89,    57,    71,    72,    92,    73,    74,
      91,    57,    57,    89,    89,    89,    70,    70,    65,     3,
       3,    79,    66,    92,    92,    93,    93,    57,    57,    57,
      89,    89,     5,    78,    65,    65,    57,    57,     3,    66,
      78,    78,    69,    78,    67,    66,    66,    78,    68,    67,
      67,     8,    25,    83,    84,    85,    86,    88,    83,    65,
      57,    89,    68,    83,    83,    68,    89,    57,    66,    67,
      83,    68,     9,     8,    67,    65,    83,    89,    68,    66,
      67,    83,    68,     9,    67,    83,    68
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr1[] =
{
       0,    75,    76,    77,    78,    78,    78,    79,    79,    80,
      80,    81,    82,    83,    83,    83,    84,    84,    85,    85,
      86,    86,    86,    87,    87,    88,    88,    88,    88,    88,
      88,    88,    88,    88,    89,    90,    90,    90,    90,    90,
      91,    91,    92,    92,    92,    93,    93,    93
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     3,     7,     0,     3,     4,     0,     2,     1,
       1,     8,     8,     0,     2,     2,     1,     1,     2,     3,
       7,    11,    19,     1,     2,     5,     5,     4,     4,     5,
       4,     6,     6,     3,     1,     3,     3,     2,     2,     1,
       1,     1,     3,     3,     1,     1,     1,     3
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


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

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


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




# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
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
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
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
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
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
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
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






/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
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
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

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
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
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
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
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

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
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
  case 2: /* prog: decl_vars main subprogs  */
#line 35 "parser.y"
                               {}
#line 1424 "y.tab.c"
    break;

  case 3: /* main: VOID MAIN '(' args ')' '{' '}'  */
#line 38 "parser.y"
                                      {}
#line 1430 "y.tab.c"
    break;

  case 5: /* args: TYPE ID args  */
#line 42 "parser.y"
                      {}
#line 1436 "y.tab.c"
    break;

  case 6: /* args: TYPE ID ',' args  */
#line 43 "parser.y"
                          {}
#line 1442 "y.tab.c"
    break;

  case 8: /* subprogs: subprog subprogs  */
#line 47 "parser.y"
                               {}
#line 1448 "y.tab.c"
    break;

  case 9: /* subprog: decl_funcao  */
#line 50 "parser.y"
                                {}
#line 1454 "y.tab.c"
    break;

  case 10: /* subprog: decl_procedimento  */
#line 51 "parser.y"
                                {}
#line 1460 "y.tab.c"
    break;

  case 11: /* decl_funcao: TYPE ID '(' args ')' '{' bloco '}'  */
#line 54 "parser.y"
                                                       {}
#line 1466 "y.tab.c"
    break;

  case 12: /* decl_procedimento: VOID ID '(' args ')' '{' bloco '}'  */
#line 57 "parser.y"
                                                        {}
#line 1472 "y.tab.c"
    break;

  case 14: /* bloco: decl_variavel bloco  */
#line 60 "parser.y"
                             {}
#line 1478 "y.tab.c"
    break;

  case 15: /* bloco: comando bloco  */
#line 61 "parser.y"
                            {}
#line 1484 "y.tab.c"
    break;

  case 16: /* comando: condicional  */
#line 64 "parser.y"
                      {}
#line 1490 "y.tab.c"
    break;

  case 17: /* comando: retorno  */
#line 65 "parser.y"
                  {}
#line 1496 "y.tab.c"
    break;

  case 18: /* retorno: RETURN PV  */
#line 68 "parser.y"
                     {}
#line 1502 "y.tab.c"
    break;

  case 19: /* retorno: RETURN expressao PV  */
#line 69 "parser.y"
                               {}
#line 1508 "y.tab.c"
    break;

  case 20: /* condicional: IF '(' expressao ')' '{' bloco '}'  */
#line 72 "parser.y"
                                                   {}
#line 1514 "y.tab.c"
    break;

  case 21: /* condicional: IF '(' expressao ')' '{' bloco '}' ELSE '{' bloco '}'  */
#line 73 "parser.y"
                                                                     {}
#line 1520 "y.tab.c"
    break;

  case 22: /* condicional: IF '(' expressao ')' '{' bloco '}' ELSE IF '(' expressao ')' '{' bloco '}' ELSE '{' bloco '}'  */
#line 74 "parser.y"
                                                                                                             {}
#line 1526 "y.tab.c"
    break;

  case 23: /* decl_vars: decl_variavel  */
#line 77 "parser.y"
                           {}
#line 1532 "y.tab.c"
    break;

  case 24: /* decl_vars: decl_variavel decl_vars  */
#line 78 "parser.y"
                                    {}
#line 1538 "y.tab.c"
    break;

  case 25: /* decl_variavel: TYPE ID '=' expressao PV  */
#line 81 "parser.y"
                                       {}
#line 1544 "y.tab.c"
    break;

  case 26: /* decl_variavel: TYPE ID MOREISEQUAL expressao PV  */
#line 82 "parser.y"
                                                {}
#line 1550 "y.tab.c"
    break;

  case 27: /* decl_variavel: ID MOREISEQUAL expressao PV  */
#line 83 "parser.y"
                                           {}
#line 1556 "y.tab.c"
    break;

  case 28: /* decl_variavel: ID LESSISEQUAL expressao PV  */
#line 84 "parser.y"
                                           {}
#line 1562 "y.tab.c"
    break;

  case 29: /* decl_variavel: TYPE ID LESSISEQUAL expressao PV  */
#line 85 "parser.y"
                                                {}
#line 1568 "y.tab.c"
    break;

  case 30: /* decl_variavel: ID '=' expressao PV  */
#line 86 "parser.y"
                                    {}
#line 1574 "y.tab.c"
    break;

  case 31: /* decl_variavel: CONST TYPE ID '=' expressao PV  */
#line 87 "parser.y"
                                                {}
#line 1580 "y.tab.c"
    break;

  case 32: /* decl_variavel: FINAL TYPE ID '=' expressao PV  */
#line 88 "parser.y"
                                               {}
#line 1586 "y.tab.c"
    break;

  case 33: /* decl_variavel: TYPE ID PV  */
#line 89 "parser.y"
                           {}
#line 1592 "y.tab.c"
    break;

  case 34: /* expressao: expre_arit  */
#line 92 "parser.y"
                        {}
#line 1598 "y.tab.c"
    break;

  case 35: /* expre_arit: expre_arit '+' termo  */
#line 95 "parser.y"
                                 {}
#line 1604 "y.tab.c"
    break;

  case 36: /* expre_arit: expre_arit '-' termo  */
#line 96 "parser.y"
                                   {}
#line 1610 "y.tab.c"
    break;

  case 37: /* expre_arit: ops termo  */
#line 97 "parser.y"
                        {}
#line 1616 "y.tab.c"
    break;

  case 38: /* expre_arit: termo ops  */
#line 98 "parser.y"
                        {}
#line 1622 "y.tab.c"
    break;

  case 39: /* expre_arit: termo  */
#line 99 "parser.y"
                    {}
#line 1628 "y.tab.c"
    break;

  case 40: /* ops: INCREMENT  */
#line 102 "parser.y"
               {}
#line 1634 "y.tab.c"
    break;

  case 41: /* ops: DECREMENT  */
#line 103 "parser.y"
                 {}
#line 1640 "y.tab.c"
    break;

  case 42: /* termo: termo '*' fator  */
#line 106 "parser.y"
                       {}
#line 1646 "y.tab.c"
    break;

  case 43: /* termo: termo '/' fator  */
#line 107 "parser.y"
                          {}
#line 1652 "y.tab.c"
    break;

  case 44: /* termo: fator  */
#line 108 "parser.y"
                {}
#line 1658 "y.tab.c"
    break;

  case 45: /* fator: ID  */
#line 111 "parser.y"
          {}
#line 1664 "y.tab.c"
    break;

  case 46: /* fator: NUMBER  */
#line 112 "parser.y"
               {}
#line 1670 "y.tab.c"
    break;

  case 47: /* fator: '(' expressao ')'  */
#line 113 "parser.y"
                          {}
#line 1676 "y.tab.c"
    break;


#line 1680 "y.tab.c"

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
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

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
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      yyerror (YY_("syntax error"));
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
  ++yynerrs;

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

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
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
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
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
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif

  return yyresult;
}

#line 115 "parser.y"


int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}
