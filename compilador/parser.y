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
%token THROWS TRY CATCH FINALLY FUNCTION SWITCH BREAK CASE CONTINUE DEFAULT
%token RETURN PRINT PRINTLN SCANF STRUCT MALLOC OPENFILE READLINE
%token WRITEFILE CLOSEFILE FREE SIZEOF CONCAT LENGHT SPLIT INCLUDES
%token REPLACE PUSH POP INDEXOF REVERSE SLICE AND OR SINGLELINECOMMENT
%token LESSTHENEQ MORETHENEQ ISEQUAL ISDIFFERENT ANDCIRCUIT ORCIRCUIT NUMBERFLOAT PV
%token TRUE FALSE DECREMENT INCREMENT MOREISEQUAL LESSISEQUAL EQUAL

%start prog

%type decl_vars decl_variavel expressao expre_arit termo fator ops main args subprogs subprog decl_funcao decl_procedimento bloco comando condicional retorno iteracao selecao casos caso decl_arrays elementos_array base decl_array decl_recursiva

%%
prog : decl_recursiva main subprogs {}
      ;

main : VOID MAIN '(' args ')' '{' bloco '}' {}
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
      | iteracao {} 
      | selecao {}
      ;

iteracao : WHILE '(' expressao ')' '{' bloco '}' {}
	| FOR '(' expressao_for expressao PV expressao_for ')' '{' bloco '}'
      ;

expressao_for : decl_variavel
	| ID INCREMENT
	| ID DECREMENT
	;

selecao : SWITCH '(' ID ')' '{' casos '}' {}
      ;

casos : caso casos {}
	| caso {}
	;

caso : CASE NUMBER ':' bloco BREAK PV{}
	| DEFAULT ':' bloco BREAK PV{}
	;

retorno : RETURN PV  {}
      | RETURN expressao  PV  {}
      ;

condicional : IF '(' expressao ')' '{' bloco '}'   {}
      | IF '(' expressao ')' '{' bloco '}' ELSE '{' bloco '}'  {}
      | IF '(' expressao ')' '{' bloco '}' ELSE IF '(' expressao ')' '{' bloco '}' ELSE '{' bloco '}'  {}
      ;

decl_vars : decl_variavel  {}
      | decl_array {}
      ;

decl_recursiva : decl_vars {}
      | decl_vars decl_recursiva {}
      ;

decl_array : TYPE '[' expressao ']' ID '=' '[' elementos_array ']' PV {}
      | ID '=' '['  elementos_array  ']' PV {}
      | CONST TYPE '[' expressao ']' ID '=' '[' elementos_array ']' PV {}
      | FINAL TYPE '[' expressao ']' ID '=' '[' elementos_array ']' PV {}
      | TYPE '[' expressao ']' ID PV {} 
      ;

elementos_array : {}
      | base {}
      | base ',' elementos_array {}
      ;

decl_variavel : TYPE ID '=' expressao PV{}
      | TYPE ID MOREISEQUAL expressao PV{}
      | ID MOREISEQUAL expressao PV{}
      | ID LESSISEQUAL expressao PV{}
      | TYPE ID LESSISEQUAL expressao PV{}
      | ID '=' expressao PV {}
      | CONST TYPE ID  '=' expressao PV {}
      | FINAL TYPE ID  '=' expressao PV{}
      | TYPE ID PV {}
      ;

expressao : 
	   expre_logica {}
|expre_arit {}
      ;

expre_logica : termo ANDCIRCUIT termo
                    | termo ORCIRCUIT termo
                    | '!' fator
                    | termo LESSTHENEQ termo
                    | termo MORETHENEQ termo
                    | termo '<' termo
                    | termo '>' termo
                    | termo ISEQUAL termo
                    | termo ISDIFFERENT termo
                    ;

expre_arit : expre_arit '+' termo {}
      | expre_arit '-' termo {}
      | ops termo {}
      | termo ops {}
      | termo {}
      ;
	    
ops: INCREMENT {}
     | DECREMENT {}
     ;

termo: termo '*' fator {}
	| termo '/' fator {}
	| termo '%' fator {}
	| fator {}
	;

fator : fator '^' base {}
      | base {}
      ;

base : ID {}
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
