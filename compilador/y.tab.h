/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

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
	

#line 202 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
