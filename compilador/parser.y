%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./lib/record.h"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;
extern FILE * yyin, * yyout;

char * cat(char *, char *, char *, char *, char *);

%}

%union {
	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
      struct record * rec;
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
%left OR 
%left AND 
%left ANDCIRCUIT ORCIRCUIT
%left LESSTHENEQ MORETHENEQ '<' '>' ISEQUAL ISDIFFERENT
%left '+' '-'
%left '*' '/' '%'
%right '^'
%right '!'
%nonassoc UMINUS


%type <rec> decl_vars decl_variavel expre_logica expre_arit termo fator 
%type <rec> ops main args subprogs subprog decl_funcao decl_procedimento bloco comando args_com_vazio alocacao_memoria liberacao_memoria
%type <rec> condicional retorno iteracao selecao casos caso elementos_array base casoDefault listaCasos
%type <rec> decl_array tamanho_array definicao_struct lista_campos atribuicao_struct expressao_tamanho_array elemento_matriz definicao_enum lista_enum decl_array_atr_tipada decl_array_atr
%type <rec> entrada saida comentario_selecao comentario decl_var_atr_tipada decl_var_atr decl_var_ponteiro decl_var_const decl_var saida_atribuicao
%type <rec> tipo_endereco tipo_ponteiro stmts base_case_array expressao_for_inicial parametros_rec parametro acesso_array parametro_com_vazio tipo tipo_array

%start prog

%%
prog : stmts main subprogs {fprintf(yyout, "%s\n%s\n%s", $1->code, $2->code, $3->code);
                           freeRecord($1);
                           freeRecord($2);
                           freeRecord($3);
                           }
      ;

stmts: {$$ = createRecord("","");}
      | decl_vars stmts {
            char * s = cat($1->code, "\n", $2->code, "", "");
            freeRecord($1);
            freeRecord($2);
            $$ = createRecord(s, "");
            free(s);
      }
      | comentario  stmts {}
      | definicao_enum stmts {}
      | definicao_struct stmts {}
      ;

main : VOID MAIN '(' args_com_vazio ')' '{' bloco '}' {
      char *s = cat("int main(", $4->code, "){\n", $7->code,"}");
      freeRecord($4);
      freeRecord($7);
      free(s);
      }
      ;

tipo_ponteiro: TYPE '*' {}
		  ;

ponteiro: '*' ID {}
          ;

tipo_endereco: TYPE '&' {}
		  ;

endereco: '&' ID {}
          ;

tipo_array: TYPE tamanho_array {}
            ;

tipo: TYPE {}
      | tipo_endereco {}
      | tipo_ponteiro {}
      | tipo_array {}
      | ID {}
      ;
 
args : tipo ID   {}
      | tipo ID ',' args  {}
      ;

args_com_vazio : {}
               | args
      ;

subprogs : {$$ = createRecord("","");}                                                       
      | subprog subprogs       {}                                              
      ;

subprog : decl_funcao           {}                                              
      | decl_procedimento        {}                                           
      ;

decl_funcao : tipo ID '(' args_com_vazio ')' '{' bloco '}'       {}           
            ;

decl_procedimento : VOID ID '(' args_com_vazio ')' '{' bloco '}'  {}                   
                  ;

bloco : {$$ = createRecord("","");}
      | decl_variavel bloco  {}
      | decl_array bloco  {}
      | comando bloco       {} 
      | ID ops PV bloco {}
      | ops ID PV bloco {}   
      | comentario bloco {}
      | liberacao_memoria {}            
      ;

comando : condicional {}
      | retorno {}
      | iteracao {} 
      | selecao {}
      | chamada_funcao PV {} 
      | entrada {}
      | saida {}
      | atribuicao_struct {}
      | definicao_struct {}
      ;

definicao_enum : ENUM ID '{' lista_enum '}' PV {}
               ;

lista_enum : ID {}
          | ID ',' lista_enum {}
          ;

definicao_struct : STRUCT ID '{' lista_campos '}' {}
                 | STRUCT tipo ID PV {}
                 ;

atribuicao_struct : ID '.' ID '=' termo PV {} 
                 ;

lista_campos : decl_vars {}
             | decl_vars lista_campos {}
             ;

iteracao : WHILE '(' expre_logica_iterador ')' '{' bloco '}' {}
	     | FOR '(' expressao_for_inicial expre_logica_iterador PV expressao_for_final ')' '{' bloco '}' {}
           ;

expre_logica_iterador: expre_logica {}
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

caso : CASE base_case_array ':' bloco BREAK PV comentario_selecao  {}
	;

casoDefault : DEFAULT ':' bloco BREAK PV comentario_selecao {}
	       ;

retorno : RETURN PV  {}
        | RETURN expre_logica  PV  {}
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

chamada_funcao : ID '(' parametro_com_vazio ')' {}
               ;

alocacao_memoria : '(' tipo_ponteiro ')' MALLOC '(' alocacao_memoria_parametros ')'  {}
               ;

alocacao_memoria_parametros : expre_arit  {}
                              |chamada_funcao {} 
                              ;

liberacao_memoria : FREE '(' ID ')' PV {}
               ;

entrada : PRINTLN '(' expre_logica ')' PV {} 
        | PRINT '(' expre_logica ')' PV {} 
        ;

saida : SCANF '(' WORD ',' ID ')' PV {}
      | SCANF '(' WORD ',' ID acesso_array ')' PV {}
      | SCANF '(' WORD ',' endereco ')' PV {}
      | SCANF '(' WORD ',' endereco acesso_array ')' PV {}
      | saida_atribuicao {}
      ;

saida_atribuicao: TYPE ID '=' saida {}
      | FINAL TYPE ID '=' saida {}
      | CONST TYPE ID '=' saida {}
      | ID '=' saida {}
      ;

decl_vars : decl_variavel  {}
            | decl_array {}
            ;

decl_array : tipo_array ID '=' '[' elementos_array ']' PV {}
            | tipo_array ID '='  expre_logica  PV {}
            | ID '=' '['  elementos_array  ']' PV {}
            | CONST tipo_array ID '=' '[' elementos_array ']' PV {}
            | FINAL tipo_array ID '=' '[' elementos_array ']' PV {}
            | tipo_array ID PV {} 
            | decl_array_atr_tipada
            | decl_array_atr
            ;

decl_array_atr_tipada: tipo_array ID MOREISEQUAL expre_logica PV{}
                  | tipo_array ID  LESSISEQUAL expre_logica PV{}
                  | tipo_array ID '=' chamada_funcao PV {}
                  ;

decl_array_atr: ID tamanho_array '=' expre_logica PV {}
            | ID tamanho_array '=' ponteiro PV {}
            | ID tamanho_array MOREISEQUAL expre_logica PV {}
            | ID tamanho_array LESSISEQUAL expre_logica PV {}
            | ID tamanho_array '=' chamada_funcao PV {}
            ;
            
tamanho_array: '[' expressao_tamanho_array ']'  {}
             | '[' expressao_tamanho_array ']' tamanho_array {}
             ;

expressao_tamanho_array:  ID {}
                         | NUMBER {}
                         ;

elemento_matriz:  '[' elementos_array ']' {}
                  | '[' elementos_array ']' ',' elemento_matriz {}
                  ;

elementos_array :  base_case_array {}
                  | base_case_array ',' elementos_array {}
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

decl_var_atr_tipada:  TYPE ID '=' expre_logica PV{}
                  | TYPE ID MOREISEQUAL expre_logica PV{}
                  | TYPE ID LESSISEQUAL expre_logica PV{}
                  | TYPE ID '=' chamada_funcao PV {}
                  ;

decl_var_atr: ID '=' expre_logica PV {}
            | ID '=' ponteiro PV {}
            | ID MOREISEQUAL expre_logica PV {}
            | ID LESSISEQUAL expre_logica PV {}
            | ID '=' chamada_funcao PV {}
            ;

decl_var: TYPE ID PV {
char *s = cat("$1","$2",";","","");
      free($1);
      free($2);
      free(s);
      }
      ;
      
decl_var_const: CONST TYPE ID  '=' expre_logica PV {}
              | FINAL TYPE ID  '=' expre_logica PV {}
              ;

decl_var_ponteiro : ponteiro '=' ID PV {}
                  | ponteiro '=' ponteiro PV {}
                  | ponteiro '=' endereco PV {}
                  | tipo_ponteiro ID '=' alocacao_memoria PV{}
                  | ID '=' alocacao_memoria  PV {}
                  | tipo_ponteiro ID PV {}
                  ;
      
parametros_rec : parametro {}
               | parametro ',' parametros_rec {}
               ;

parametro : expre_logica {}
           | tipo '.' ID {}
           ;

parametro_com_vazio: {}
                    | parametros_rec
            ;

expre_logica : expre_logica ANDCIRCUIT expre_logica {} 
             | expre_logica ORCIRCUIT expre_logica {}
             | expre_logica AND expre_logica {}
             | expre_logica OR expre_logica {}
             | expre_logica LESSTHENEQ expre_logica {}
             | expre_logica MORETHENEQ expre_logica {}
             | expre_logica '<' expre_logica {}
             | expre_logica '>' expre_logica {}
             | expre_logica ISEQUAL expre_logica {}
             | expre_logica ISDIFFERENT expre_logica {}
             | '!'  expre_logica {}
             | expre_logica_par {}
             | expre_arit {}
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
      | endereco acesso_array {}
      | endereco {}
      | base {}
      ;

expre_logica_par: '(' expre_logica ')' {}
      ;

base : ID {}
      | NUMBER {}
      | NUMBERFLOAT {}
      | WORD {}
      | TRUE {}
      | FALSE {}
      ;

base_case_array: ID {}
                  | NUMBER {}
                  | NUMBERFLOAT {}
                  | WORD {}
                  | TRUE {}
                  | FALSE {}
                  ;

comentario: COMMENT {}
            ;
%%

int main (int argc, char ** argv) {
	 int codigo;

    if (argc != 3) {
      printf("Usage: $./compiler input.txt output.txt\nClosing application...\n");
      exit(0);
    }
    
    yyin = fopen(argv[1], "r");
    yyout = fopen(argv[2], "w");

    codigo = yyparse();

    fclose(yyin);
    fclose(yyout);

    return codigo;
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}

char * cat(char * s1, char * s2, char * s3, char * s4, char * s5){
  int tam;
  char * output;

  tam = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4) + strlen(s5)+ 1;
  output = (char *) malloc(sizeof(char) * tam);
  
  if (!output){
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }
  
  sprintf(output, "%s%s%s%s%s", s1, s2, s3, s4, s5);
  
  return output;
}