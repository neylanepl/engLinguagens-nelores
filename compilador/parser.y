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
%type decl_array tamanho_array definicao_struct lista_campos atribuicao_struct expressao_tamanho_array elemento_matriz definicao_enum lista_enum
%type entrada saida comentario_selecao comentario decl_var_atr_tipada decl_var_atr decl_var_ponteiro decl_var_const decl_var
%type  tipo_endereco tipo_ponteiro stmts base_elemento_array expressao_for_inicial parametros_rec parametro acesso_array

%%
prog : stmts main subprogs {}
      ;

main : VOID MAIN '(' args ')' '{' bloco '}' {}
      ;

stmts: {}
      | decl_vars stmts {}
      | comentario  stmts {}
      ;

tipo_ponteiro: '*' ID  {}
		  ;

tipo_endereco: '&' ID  {}
		  ;

args : {}
      | TYPE ID   {}
      | ID ID   {}
      | TYPE tipo_ponteiro   {}
      | tipo_endereco   {}
      | TYPE ID ',' args  {}
      | tipo_endereco ',' args  {}
      | TYPE tipo_ponteiro ',' args  {}
      | TYPE tamanho_array ID {}
      | TYPE tamanho_array ID ',' args {}
      ;

subprogs :                                                              
      | subprog subprogs       {}                                              
      ;

subprog : decl_funcao           {}                                              
      | decl_procedimento        {}                                           
      ;

decl_funcao : TYPE ID '(' args ')' '{' bloco '}'       {}        
              | ID ID '(' args ')' '{' bloco '}'       {}      
            ;

decl_procedimento : VOID ID '(' args ')' '{' bloco '}'  {}                   
                  ;

bloco : 
      | decl_variavel bloco  {}
      | decl_array bloco  {}
      | comando bloco       {} 
      | ID ops PV bloco {}
      | ops ID PV bloco {}   
      | comentario bloco {}                    
      ;

comando : condicional {}
      | retorno {}
      | iteracao {} 
      | selecao {}
      | chamada_funcao{} 
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
		     |  ID '.' ID PV {}
                 | STRUCT ID ID PV {}
                 ;

atribuicao_struct : ID '.' ID '=' termo PV {} 
                 ;

lista_campos : decl_vars {}
             | decl_vars lista_campos {}
             ;

iteracao : WHILE '(' expre_logica_iterador ')' '{' bloco '}' {}
	     | FOR '(' expressao_for_inicial expre_logica_iterador PV expressao_for_final ')' '{' bloco '}' {}
           ;

expre_logica_iterador: expre_logica_negacao {}
                     | TRUE {}
                     | FALSE {}
                     ;

expressao_for_inicial : decl_var_atr_tipada {}
                      | decl_var_atr {}
                      | decl_var {}
                      ;

expressao_for_final : expre_arit {}
                    ;

selecao : SWITCH '(' ID ')' '{' comentario_selecao  casos '}' {}
      ;

comentario_selecao: {}
                  | comentario comentario_selecao{}
                  ;

casos : listaCasos casoDefault {}
      | listaCasos {} 
      | casoDefault {}
      ;

listaCasos : caso listaCasos {}
           | caso  {}
           ;

caso : CASE caseBase ':' bloco BREAK PV comentario_selecao  {}
	;

casoDefault : DEFAULT ':' bloco BREAK PV comentario_selecao {}
	       ;

retorno : RETURN PV  {}
        | RETURN expressao  PV  {}
        ;

condicional : if_simples condicional_aux {}
            ;

condicional_aux : 
                | elseif condicional_aux {}
                | else {}
                ;

else : ELSE '{' bloco '}'  {}
     ;

elseif : ELSE IF '(' expre_logica_iterador ')' '{' bloco '}' {}
       ;

if_simples : IF '(' expre_logica_iterador ')' '{' bloco '}' {}
            ;

chamada_funcao : ID '(' parametros_rec ')' PV {}
               ;

entrada : PRINTLN '(' expressao ')' PV {} 
        | PRINT '(' expressao ')' PV {} 
        | PRINT '(' expressao ',' ID tamanho_array ')' PV {} 
        ;

saida : TYPE ID '=' SCANF '(' ')' PV {}
      | FINAL TYPE ID '=' SCANF '(' ')' PV {}
      | CONST TYPE ID '=' SCANF '(' ')' PV {}
      | ID '=' SCANF '(' ')' PV {}
      | SCANF '(' WORD ',' ID acesso_array ')' PV {}
      | SCANF '(' WORD ',' tipo_endereco ')' PV {}
      | SCANF '(' WORD ',' tipo_endereco acesso_array ')' PV {}
      ;

decl_vars : decl_variavel  {}
            | decl_array {}
            ;

decl_array : TYPE tamanho_array ID '=' '[' elementos_array ']' PV {}
            | ID '=' '['  elementos_array  ']' PV {}
            | CONST TYPE tamanho_array ID '=' '[' elementos_array ']' PV {}
            | FINAL TYPE tamanho_array ID '=' '[' elementos_array ']' PV {}
            | TYPE tamanho_array ID PV {} 
            ;
            
tamanho_array: '[' expressao_tamanho_array ']'  {}
             | '[' expressao_tamanho_array ']' tamanho_array {}
             ;


expressao_tamanho_array: | ID {}
                         | NUMBER {}
                         ;

elemento_matriz: '[' elementos_array ']' {}
                  | '[' elementos_array ']' ',' elemento_matriz {}
                  ;

elementos_array : {}
                  | base_elemento_array {}
                  | base_elemento_array ',' elementos_array {}
                  | elemento_matriz {}
                  ;

acesso_array: '[' expre_arit ']'  {}
            | '[' expre_arit ']' acesso_array {}
            ;

decl_variavel : decl_var_atr_tipada {}
              | decl_var_atr {}
              | decl_var_ponteiro {}
              | decl_var_const {}
              | decl_var {}
              ;

decl_var_atr_tipada:  TYPE ID '=' expressao PV{}
                  | TYPE ID MOREISEQUAL expressao PV{}
                  | TYPE ID LESSISEQUAL expressao PV{}
                  | TYPE ID '=' chamada_funcao {}
                  ;

decl_var_atr: ID '=' expressao PV {}
            | ID '=' tipo_ponteiro PV {}
            | ID MOREISEQUAL expressao PV {}
            | ID LESSISEQUAL expressao PV {}
            | ID '=' chamada_funcao {}
            ;

decl_var: TYPE ID PV {}
          ;
      
decl_var_const: CONST TYPE ID  '=' expressao PV {}
              | FINAL TYPE ID  '=' expressao PV {}
              ;

decl_var_ponteiro : tipo_ponteiro '=' ID PV {}
                  | tipo_ponteiro '=' tipo_ponteiro PV {}
                  | tipo_ponteiro '=' tipo_endereco PV {}
                  | TYPE tipo_ponteiro PV {}
                  ;
      
parametros_rec : parametro {}
               | parametro ',' parametros_rec {}
               ;

parametro :
           | expressao {}
           | ID '.' ID
           ;

expressao : expre_logica_negacao {}
          | expre_arit {}
          ;

expre_logica_negacao: expre_logica {}
                    | '!' expre_logica_negacao {}
                    ;

expre_logica : expre_arit ANDCIRCUIT expre_arit {} 
             | expre_arit ORCIRCUIT expre_arit {}
             | expre_arit LESSTHENEQ expre_arit {}
             | expre_arit MORETHENEQ expre_arit {}
             | expre_arit '<' expre_arit {}
             | expre_arit '>' expre_arit {}
             | expre_arit ISEQUAL expre_arit {}
             | expre_arit ISDIFFERENT expre_arit {}
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
      | ID acesso_array {}
      | tipo_endereco acesso_array {}
      | tipo_endereco {}
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

base_elemento_array: ID {}
                  | NUMBER {}
                  | NUMBERFLOAT {}
                  | WORD {}
                  | TRUE {}
                  | FALSE {}
                  ;

caseBase: ID {}
        | NUMBER {}
        | NUMBERFLOAT {}
        | WORD {}
        | TRUE {}
        | FALSE {}
        ;

comentario: COMMENT {}
            ;
%%

int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}