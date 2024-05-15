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

%type decl_vars decl_variavel expressao expre_arit termo fator ops main args subprogs subprog decl_funcao decl_procedimento bloco comando condicional retorno

%%
prog : decl_vars main subprogs {} 
       ;

main : VOID MAIN '(' args ')' '{' '}' {}
     ;

args : 
      | TYPE ID args  {}
      | TYPE ID ',' args  {}
      ;

subprogs :                                                              
      | subprog subprogs       {}                                              
      ;

subprog : decl_funcao           {}                                              
     | decl_procedimento        {}                                           
     ;

decl_funcao : TYPE ID '(' args ')' '{' bloco '}'       {}        
       ;

decl_procedimento : VOID ID '(' args ')' '{' bloco '}'  {}                   
             ;
bloco : 
      | decl_variavel bloco  {}
      | comando bloco       {}                               
      ;

comando : condicional {}
	| retorno {}
        ;     

retorno : RETURN PV  {}
       | RETURN expressao  PV  {}
       ;

condicional : IF '(' expressao ')' '{' bloco '}'   {}
            | IF '(' expressao ')' '{' bloco '}' ELSE '{' bloco '}'  {}
	    | IF '(' expressao ')' '{' bloco '}' ELSE IF '(' expressao ')' '{' bloco '}' ELSE '{' bloco '}'  {}
            ;

decl_vars : decl_variavel  {}
          | decl_variavel decl_vars {}
          ;

decl_variavel: TYPE ID '=' expressao PV{}
	      | ID '=' expressao PV {}
	      | CONST TYPE ID  '=' expressao PV {}
              | FINAL TYPE ID  '=' expressao PV{}
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
