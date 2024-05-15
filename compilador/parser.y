%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

%}

%union {
	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
	};

%token <sValue> ID
%token <iValue> NUMBER
%token <sValue> TYPE
%token WHILE FOR IF ELSE CONST FINAL ENUM  MAIN VOID EXCEPTION
%token THROWS TRY CATCH FINALLY FUNCTION SWITCH BREAK CASE CONTINUE
%token RETURN PRINT PRINTLN SCANF STRUCT MALLOC OPENFILE READLINE
%token WRITEFILE CLOSEFILE FREE SIZEOF CONCAT LENGHT SPLIT INCLUDES
%token REPLACE PUSH POP INDEXOF REVERSE SLICE AND OR SINGLELINECOMMENT
%token LESSTHENEQ MORETHENEQ ISEQUAL ISDIFFERENT ANDCIRCUIT ORCIRCUIT NUMBERFLOAT PV
%token TRUE FALSE DECREMENT INCREMENT MOREISEQUAL LESSISEQUAL EQUAL

%start prog

%type decl_vars decl_variavel expressao expre_arit termo fator ops


%%
prog : decl_vars {} 
       ;

decl_vars : decl_variavel  {}
          | decl_variavel decl_vars {}
          ;

decl_variavel: TYPE ID '=' expressao PV{}
	      | CONST TYPE ID PV {}
              | FINAL TYPE ID PV {}
	      | TYPE ID PV {}
              ;

expressao :  expre_arit {}
	     ;
	  	    
expre_arit: expre_arit '+' termo {}
	    | expre_arit '-' termo {}
	    | expre_arit MOREISEQUAL termo {}
	    | expre_arit LESSISEQUAL termo {}
	    | ops termo {}
    	    | termo ops {}
	    | termo {}
	    ;
	    
ops: INCREMENT {}
     | DECREMENT {}
     ;

termo: termo '*' fator {}
	| termo '/' fator {}
	| fator {}
	;

fator: ID {}
      | NUMBER {}
      | '(' expressao ')' {}
      ;
%%

int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}

