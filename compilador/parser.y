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
%token <sValue> WORD
%token <sValue> NUMBERFLOAT
%token <iValue> NUMBER
%token <sValue> TYPE
%token WHILE FOR IF ELSE CONST FINAL ENUM  MAIN VOID EXCEPTION
%token THROWS TRY CATCH FINALLY FUNCTION SWITCH BREAK CASE CONTINUE DEFAULT
%token RETURN PRINT PRINTLN SCANF STRUCT MALLOC OPENFILE READLINE
%token WRITEFILE CLOSEFILE FREE SIZEOF CONCAT LENGHT SPLIT INCLUDES
%token REPLACE PUSH POP INDEXOF REVERSE SLICE AND OR SINGLELINECOMMENT 
%token LESSTHENEQ MORETHENEQ ISEQUAL ISDIFFERENT ANDCIRCUIT ORCIRCUIT  PV
%token TRUE FALSE DECREMENT INCREMENT MOREISEQUAL LESSISEQUAL EQUAL  COMMENT

%start prog

%type decl_vars decl_variavel expressao expre_arit termo fator 
%type ops main args subprogs subprog decl_funcao decl_procedimento bloco comando 
%type condicional retorno iteracao selecao casos caso elementos_array base caseBase casoDefault listaCasos
%type decl_array decl_recursiva tamanho_array definicao_struct lista_campos atribuicao_struct expressao_tamanho_array elemento_matriz definicao_enum lista_enum
%type entrada saida  
%type tipo tipo_endereco tipo_ponteiro

%%
prog : decl_recursiva main subprogs {}
      ;

main : VOID MAIN '(' args ')' '{' bloco '}' {}
      ;

tipo: TYPE {}
      | tipo tipo_ponteiro {}
      | tipo_endereco {}
      ;

tipo_ponteiro: '*' ID  {}
		;

tipo_endereco: '&' ID  {}
		;

args : 
      | tipo ID args  {}
      | tipo args  {}
      | tipo ',' args  {}
      | tipo ID ',' args  {}
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
      | decl_array bloco  {}
      | comando bloco       {} 
      | ID ops PV bloco {}
      | ops ID PV bloco {}   
      | commentario bloco {}                    
      ;

comando : condicional {}
      | retorno {}
      | iteracao {} 
      | selecao {}
      | chamada_funcao {} 
      | entrada {}
      | saida {}
      | definicao_enum {}
      | atribuicao_struct {}
      | definicao_struct {}
      ;

definicao_enum : ENUM ID '{' lista_enum '}' PV {}
               ;

lista_enum : ID {}
          | ID ',' lista_enum {}
          ;

definicao_struct : STRUCT ID '{' lista_campos '}' {}
		   | STRUCT ID ID PV {}
                 ;

atribuicao_struct : ID '.' ID '=' termo PV {}
                 ;

lista_campos : decl_vars {}
             | decl_vars lista_campos {}
             ;

iteracao : WHILE '(' expressao ')' '{' bloco '}' {}
	| FOR '(' expressao_for expressao PV expressao_for ')' '{' bloco '}' {}
      ;

expressao_for : decl_variavel {}
	| ID ops {}
	| ops ID {}
	;

selecao : SWITCH '(' ID ')' '{' casos '}' {}
      ;

casos : listaCasos casoDefault
      | listaCasos
      | casoDefault
      ;

listaCasos : caso listaCasos
           | caso 
            ;

caso : CASE caseBase ':' bloco BREAK PV
	;

casoDefault : DEFAULT ':' bloco BREAK PV
	;

retorno : RETURN PV  {}
      | RETURN expressao  PV  {}
      ;

condicional : if_solteiro condicional_aux {}
            ;

condicional_aux : 
                | elseif condicional_aux {}
                | else {}
                ;

else : ELSE '{' bloco '}'  {}
     ;

elseif : ELSE IF '(' expressao ')' '{' bloco '}' {}
       ;

if_solteiro : IF '(' expressao ')' '{' bloco '}' {}
            ;

chamada_funcao : ID '(' parametros ')' PV {}
               | ID '(' ')' PV {}
               ;

entrada : PRINTLN '(' expressao ')' PV {} 
        | PRINT '(' expressao ')' PV {} 
        ;

saida : TYPE ID '=' SCANF '(' ')' PV {}
      | FINAL TYPE ID '=' SCANF '(' ')' PV {}
      | CONST TYPE ID '=' SCANF '(' ')' PV {}
      | ID '=' SCANF '(' ')' PV {}
      ;

decl_vars : decl_variavel  {}
      | decl_array {}
      ;

decl_recursiva : decl_vars {}
               | decl_vars decl_recursiva {}
               ;

decl_array : TYPE tamanho_array ID '=' '[' elementos_array ']' PV {}
      | ID '=' '['  elementos_array  ']' PV {}
      | CONST TYPE tamanho_array ID '=' '[' elementos_array ']' PV {}
      | FINAL TYPE tamanho_array ID '=' '[' elementos_array ']' PV {}
      | TYPE tamanho_array ID PV {} 
      ;

tamanho_array: '[' expressao_tamanho_array ']'  {}
             | '[' expressao_tamanho_array ']' tamanho_array {}


expressao_tamanho_array: | ID MOREISEQUAL expre_arit {}
                         | ID LESSISEQUAL expre_arit {}
                         | expre_arit {}
                          ;

elemento_matriz: '[' elementos_array ']' {}
                  | '[' elementos_array ']' ',' elemento_matriz {}

elementos_array : {}
      | base {}
      | base ',' elementos_array {}
      | elemento_matriz
      ;

decl_variavel : TYPE ID '=' expressao PV{}
      | TYPE ID MOREISEQUAL expressao PV{}
      | ID MOREISEQUAL expressao PV{}
      | ID LESSISEQUAL expressao PV{}
      | TYPE ID LESSISEQUAL expressao PV{}
      | ID '=' expressao PV {}
      | ID '=' tipo_ponteiro PV {}
      | tipo_ponteiro '=' ID PV {}
      | tipo_ponteiro '=' tipo_ponteiro PV {}
      | tipo_ponteiro '=' tipo_endereco PV {}
      | CONST TYPE ID  '=' expressao PV {}
      | FINAL TYPE ID  '=' expressao PV{}
      | tipo PV {}
      | TYPE ID PV {}
      ;

parametros : expressao {}
           | expressao ',' parametros {}
           ;

expressao : expre_logica {}
          | expre_arit {}
          ;

expre_logica : termo ANDCIRCUIT termo {} 
                    | termo ORCIRCUIT termo {}
                    | '!' fator {}
                    | termo LESSTHENEQ termo {}
                    | termo MORETHENEQ termo {}
                    | termo '<' termo {}
                    | termo '>' termo {}
                    | termo ISEQUAL termo {}
                    | termo ISDIFFERENT termo {}
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
      | NUMBERFLOAT {}
      | WORD {}
      | TRUE {}
      | FALSE {}
      | '(' expressao ')' {}
      ;

caseBase: ID {}
      |NUMBER {}
      | NUMBERFLOAT {}
      | WORD {}
      | TRUE {}
      | FALSE {}
      ;

commentario: COMMENT {}
            ;
%%

int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}