%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./lib/record.h"
#include "./lib/semantics.h"
#include "./lib/hashTable.h"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;
extern FILE * yyin, * yyout;

char * cat(char *, char *, char *, char *, char *);
SymbolTable *variablesTable;
SymbolTable *functionsTable;
SymbolTable *typedTable;
int countFuncCallParams;
void insertFunctionParam(char *, char *);


%}

%union {
	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
      float	fValue;     /* float value */	 
	char * sValue;  /* string value */
      struct record * rec;
	};

%token <sValue> ID
%token <sValue> WORD
%token <fValue> NUMBERFLOAT
%token <iValue> NUMBER
%token <sValue> TYPE
%token WHILE FOR IF ELSE CONST FINAL ENUM  MAIN VOID EXCEPTION
%token THROWS TRY CATCH FINALLY FUNCTION SWITCH BREAK CASE CONTINUE DEFAULT
%token RETURN PRINT PRINTLN SCANF STRUCT MALLOC OPENFILE READLINE
%token WRITEFILE CLOSEFILE FREE SIZEOF CONCAT LENGHT SPLIT INCLUDES
%token REPLACE PUSH POP INDEXOF REVERSE SLICE AND OR SINGLELINECOMMENT 
%token LESSTHENEQ MORETHENEQ ISEQUAL ISDIFFERENT ANDCIRCUIT ORCIRCUIT  PV
%token PROCEDURE TRUE FALSE DECREMENT INCREMENT MOREISEQUAL LESSISEQUAL EQUAL  COMMENT
%left OR 
%left AND 
%left ANDCIRCUIT ORCIRCUIT
%left LESSTHENEQ MORETHENEQ '<' '>' ISEQUAL ISDIFFERENT
%left '+' '-'
%left '*' '/' '%'
%right '^'
%right '!'
%nonassoc UMINUS


%type <rec> decl_vars decl_variavel expre_logica expre_arit termo fator chamada_funcao
%type <rec> ops main args subprogs subprog decl_funcao decl_procedimento bloco comando args_com_vazio alocacao_memoria liberacao_memoria
%type <rec> condicional retorno iteracao selecao casos caso elementos_array base casoDefault listaCasos
%type <rec> decl_array tamanho_array definicao_struct lista_campos atribuicao_struct expressao_tamanho_array elemento_matriz definicao_enum lista_enum decl_array_atr_tipada decl_array_atr
%type <rec> entrada saida comentario_selecao comentario decl_var_atr_tipada decl_var_atr decl_var_ponteiro decl_var_const decl_var saida_atribuicao
%type <rec> tipo_endereco tipo_ponteiro stmts base_case_array expressao_for_inicial parametros_rec parametro acesso_array parametro_com_vazio tipo tipo_array

%start prog

%%
prog : stmts subprogs main {fprintf(yyout, "%s\n%s\n%s", $1->code, $2->code, $3->code);
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
      $$ = createRecord(s, "");
      free(s);
};

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

tipo: TYPE {$$ = createRecord($1,"");}
      | tipo_endereco {$$ = $1;}
      | tipo_ponteiro {$$ = $1;}
      | tipo_array {$$ = $1;}
      | ID {
            if(lookup(typedTable, $1) == NULL){
                  yyerror(cat("unknow type ",$1,"","",""));
	      } 
		$$ = createRecord($1,""); 
      }
      ;
 
args : tipo ID   {
            insert(variablesTable, $2, $2, $1->code);
	      insertFunctionParam($2, $1->code);
      }
      | tipo ID ',' args  {}
      ;

args_com_vazio : {$$ = createRecord("","");}
               | args {$$ = $1;}
      ;

subprogs : {$$ = createRecord("","");}                                                       
      | subprog subprogs       {
            char *declSubProgr = cat($1->code,$2->code,"","","");
            freeRecord($1);
            freeRecord($2);
            $$ = createRecord(declSubProgr, "");
            free(declSubProgr);
      }                                              
      ;

subprog : decl_funcao           {$$ = $1;}                                              
      | decl_procedimento        {$$ = $1;}                                           
      ;

decl_funcao : FUNCTION tipo ID '(' args_com_vazio ')' '{' bloco '}'       {
                        if (lookup(variablesTable, $3)) {
                              yyerror(cat("error: redeclaration of function ", $3, "", "", ""));
                        } else {
                              insert(functionsTable, cat($3,"","","",""),"return",$2->code);
                              declaracaoFuncao(&$$, &$3, &$5, &$2->code, &$8);
                        }  
}           
            ;

decl_procedimento : PROCEDURE ID '(' args_com_vazio ')' '{' bloco '}'  {}                   
                  ;

bloco : {$$ = createRecord("","");}
      | decl_variavel bloco  { 
            char *s = cat($1->code,$2->code,"","","");
            freeRecord($1);
            freeRecord($2);
            $$ = createRecord(s, "");
            free(s);
      }
      | decl_array bloco  {}
      | comando bloco {
            char *declComando = cat($1->code,$2->code,"","","");
            freeRecord($1);
            freeRecord($2);
            $$ = createRecord(declComando, "");
            free(declComando);
      } 
      | ID ops PV bloco {}
      | ops ID PV bloco {}   
      | comentario bloco {}
      | liberacao_memoria {}            
      ;

comando : condicional {$$ = $1;}
      | retorno {$$ = $1;}
      | iteracao {$$ = $1;} 
      | selecao {$$ = $1;}
      | chamada_funcao PV {
            char *s = cat($1->code,";\n","","","");
            freeRecord($1);
            $$ = createRecord(s, "");
            free(s);
      } 
      | entrada {$$ = $1;}
      | saida {$$ = $1;}
      | atribuicao_struct {$$ = $1;}
      | definicao_struct {$$ = $1;}
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

chamada_funcao : ID '(' parametro_com_vazio ')' {
            SymbolInfos *foundFuncReturn = lookup(functionsTable, $1);
            if(foundFuncReturn){
                  char funcType[100];
                  strcpy(funcType, foundFuncReturn->type);
                  record *rcdParam = createRecord($3->code, "");
                  chamadaParamFuncao(&$$, &$1, &rcdParam, funcType);
                  countFuncCallParams = 0;
            } else {
                  yyerror(cat("undefined function ",$1,"","",""));
            }
      }
               ;

alocacao_memoria : '(' tipo_ponteiro ')' MALLOC '(' alocacao_memoria_parametros ')'  {}
               ;

alocacao_memoria_parametros : expre_arit  {}
                              |chamada_funcao {} 
                              ;

liberacao_memoria : FREE '(' ID ')' PV {}
               ;

entrada : PRINTLN '(' expre_logica ')' PV {
            printStringLiteral(&$$, &$3->opt1); 
        } 
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

decl_vars : decl_variavel  {$$ = $1;}
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

decl_variavel : decl_var_atr_tipada {$$ = $1;}
              | decl_var_atr {$$ = $1;}
              | decl_var_ponteiro {$$ = $1;}
              | decl_var_const {$$ = $1;}
              | decl_var {$$ = $1;}
              ;

decl_var_atr_tipada:  TYPE ID '=' expre_logica PV{
                        if (lookup(variablesTable, $2)) {
                              yyerror(cat("error: redeclaration of variable ", $2, "", "", ""));
                        } else {
                              insert(variablesTable, $2, $2, $1);

                              int intfloat = !strcmp($1, "int") && !strcmp($4->code, "float");
                              int floatint = !strcmp($1, "float") && !strcmp($4->code, "int");

                              if (strcmp($1, $4->code) == 0 || intfloat || floatint) {
                                    record *rcdIdDeclTipada = createRecord($2, "");
                                    init1(&$$, &rcdIdDeclTipada, &$1, &$4);
                              } else {
                                    yyerror(cat("Initialization of ", $1, " from type ", $4->code, " is incompatible!"));
                              }
                        }  
                  }
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
    if (lookup(variablesTable, $2)) {
        yyerror(cat("error: redeclaration of variable ", $2, "", "", ""));
    }
    insert(variablesTable, $2, $2, $1);
    record *rcdIdDeclVar = createRecord($2, ""); 
    dec1(&$$, &rcdIdDeclVar, &$1);
    printf("Record declaração variavel freed\n");
};
      
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
      
parametros_rec : parametro {$$ = $1;}
               | parametro ',' parametros_rec {}
               ;

parametro : expre_logica {$$ = $1;}
           | tipo '.' ID {}
           ;

parametro_com_vazio: {$$ = createRecord("","");}
                    | parametros_rec {$$ = $1;}
            ;

expre_logica : expre_logica ANDCIRCUIT expre_logica {} 
             | expre_logica ORCIRCUIT expre_logica {} 
             | expre_logica AND expre_logica {
                  int intfloat = !(strcmp($1->opt1, "int") || strcmp($3->opt1, "float"));
                  int floatint = !(strcmp($1->opt1, "float") || strcmp($3->opt1, "int"));

                  if((0 == strcmp($1->opt1, $3->opt1)) || intfloat || floatint){
                        char inType[100];
                        strcpy(inType, $3->opt1);

                        ex2(&$$, &$1, "&&", &$3, inType);
                  } else {
                        yyerror(cat("Types ", $1->opt1, " and ", $3->opt1, " are incompatible!"));
                  }
             }
             | expre_logica OR expre_logica {
                  int intfloat = !(strcmp($1->opt1, "int") || strcmp($3->opt1, "float"));
                  int floatint = !(strcmp($1->opt1, "float") || strcmp($3->opt1, "int"));

                  if((0 == strcmp($1->opt1, $3->opt1)) || intfloat || floatint){
                        char inType[100];
                        strcpy(inType, $3->opt1);

                        ex2(&$$, &$1, "||", &$3, inType);
                  } else {
                        yyerror(cat("Types ", $1->opt1, " and ", $3->opt1, " are incompatible!"));
                  }
             }
             | expre_logica LESSTHENEQ expre_logica {
                  int intfloat = !(strcmp($1->opt1, "int") || strcmp($3->opt1, "float"));
                  int floatint = !(strcmp($1->opt1, "float") || strcmp($3->opt1, "int"));

                  if((0 == strcmp($1->opt1, $3->opt1)) || intfloat || floatint){
                        char inType[100];
                        strcpy(inType, $3->opt1);

                        ex2(&$$, &$1, "<=", &$3, inType);
                  } else {
                        yyerror(cat("Types ", $1->opt1, " and ", $3->opt1, " are incompatible!"));
                  }
             }
             | expre_logica MORETHENEQ expre_logica {
                  int intfloat = !(strcmp($1->opt1, "int") || strcmp($3->opt1, "float"));
                  int floatint = !(strcmp($1->opt1, "float") || strcmp($3->opt1, "int"));

                  if((0 == strcmp($1->opt1, $3->opt1)) || intfloat || floatint){
                        char inType[100];
                        strcpy(inType, $3->opt1);

                        ex2(&$$, &$1, ">=", &$3, inType);
                  } else {
                        yyerror(cat("Types ", $1->opt1, " and ", $3->opt1, " are incompatible!"));
                  }
             }
             | expre_logica '<' expre_logica {
                  int intfloat = !(strcmp($1->opt1, "int") || strcmp($3->opt1, "float"));
                  int floatint = !(strcmp($1->opt1, "float") || strcmp($3->opt1, "int"));

                  if((0 == strcmp($1->opt1, $3->opt1)) || intfloat || floatint){
                        char inType[100];
                        strcpy(inType, $3->opt1);

                        ex2(&$$, &$1, "<", &$3, inType);
                  } else {
                        yyerror(cat("Types ", $1->opt1, " and ", $3->opt1, " are incompatible!"));
                  }
             }
             | expre_logica '>' expre_logica {
                  int intfloat = !(strcmp($1->opt1, "int") || strcmp($3->opt1, "float"));
                  int floatint = !(strcmp($1->opt1, "float") || strcmp($3->opt1, "int"));

                  if((0 == strcmp($1->opt1, $3->opt1)) || intfloat || floatint){
                        char inType[100];
                        strcpy(inType, $3->opt1);

                        ex2(&$$, &$1, ">", &$3, inType);
                  } else {
                        yyerror(cat("Types ", $1->opt1, " and ", $3->opt1, " are incompatible!"));
                  }
             }
             | expre_logica ISEQUAL expre_logica {
                  int intfloat = !(strcmp($1->opt1, "int") || strcmp($3->opt1, "float"));
                  int floatint = !(strcmp($1->opt1, "float") || strcmp($3->opt1, "int"));

                  if((0 == strcmp($1->opt1, $3->opt1)) || intfloat || floatint){
                        char inType[100];
                        strcpy(inType, $3->opt1);

                        ex2(&$$, &$1, "==", &$3, inType);
                  } else {
                        yyerror(cat("Types ", $1->opt1, " and ", $3->opt1, " are incompatible!"));
                  }
             }
             | expre_logica ISDIFFERENT expre_logica {
                  int intfloat = !(strcmp($1->opt1, "int") || strcmp($3->opt1, "float"));
                  int floatint = !(strcmp($1->opt1, "float") || strcmp($3->opt1, "int"));

                  if((0 == strcmp($1->opt1, $3->opt1)) || intfloat || floatint){
                        char inType[100];
                        strcpy(inType, $3->opt1);

                        ex2(&$$, &$1, "!=", &$3, inType);
                  } else {
                        yyerror(cat("Types ", $1->opt1, " and ", $3->opt1, " are incompatible!"));
                  }
             }
             | '!'  expre_logica {}
             | expre_logica_par {}
             | expre_arit {$$ = $1;}
             ;
               
expre_arit : expre_arit '+' termo {
                  int intfloat = !(strcmp($1->code, "int") || strcmp($3->code, "float"));
                  int floatint = !(strcmp($1->code, "float") || strcmp($3->code, "int"));
                  printf("---- %s %s ----", $1->code, $3->code);

                  if((0 == strcmp($1->code, $3->code)) || intfloat || floatint){
                        char inType[100];
                        if (intfloat || floatint) {
                              strcpy(inType, "float"); // Resultante de int + float ou float + int deve ser float
                        } else {
                              strcpy(inType, $1->code); // Se ambos os tipos são iguais
                        }
                        ex2(&$$, &$1, "+", &$3, inType);
                  } else {
                        yyerror(cat("Types ", $1->code, " and ", $3->code, " are incompatible!"));
                  }
            }
            | expre_arit '-' termo {
                  int intfloat = !(strcmp($1->code, "int") || strcmp($3->code, "float"));
                  int floatint = !(strcmp($1->code, "float") || strcmp($3->code, "int"));

                  if((0 == strcmp($1->code, $3->code)) || intfloat || floatint){
                        char inType[100];
                        if (intfloat || floatint) {
                              strcpy(inType, "float"); // Resultante de int + float ou float + int deve ser float
                        } else {
                              strcpy(inType, $1->code); // Se ambos os tipos são iguais
                        }
                        ex2(&$$, &$1, "-", &$3, inType);
                  } else {
                        yyerror(cat("Types ", $1->code, " and ", $3->code, " are incompatible!"));
                  }
            }
            | ops termo {}
            | termo ops {}
            | termo {$$ = $1;}
            ;
	    
ops: INCREMENT {}
     | DECREMENT {}
     ;

termo: termo '*' fator {
            int intfloat = !(strcmp($1->code, "int") || strcmp($3->code, "float"));
            int floatint = !(strcmp($1->code, "float") || strcmp($3->code, "int"));

            if((0 == strcmp($1->code, $3->code)) || intfloat || floatint){
                  char inType[100];
                  if (intfloat || floatint) {
                        strcpy(inType, "float"); // Resultante de int + float ou float + int deve ser float
                  } else {
                        strcpy(inType, $1->code); // Se ambos os tipos são iguais
                  }
                  ex2(&$$, &$1, "*", &$3, inType);
            } else {
                  yyerror(cat("Types ", $1->code, " and ", $3->code, " are incompatible!"));
            }
      }
	| termo '/' fator {
            int intfloat = !(strcmp($1->code, "int") || strcmp($3->code, "float"));
            int floatint = !(strcmp($1->code, "float") || strcmp($3->code, "int"));

            if((0 == strcmp($1->code, $3->code)) || intfloat || floatint){
                  char inType[100];
                  if (intfloat || floatint) {
                        strcpy(inType, "float"); // Resultante de int + float ou float + int deve ser float
                  } else {
                        strcpy(inType, $1->code); // Se ambos os tipos são iguais
                  }
                  ex2(&$$, &$1, "/", &$3, inType);
            } else {
                  yyerror(cat("Types ", $1->code, " and ", $3->code, " are incompatible!"));
            }
      }
	| termo '%' fator {
            int intfloat = !(strcmp($1->code, "int") || strcmp($3->code, "float"));
            int floatint = !(strcmp($1->code, "float") || strcmp($3->code, "int"));

            if((0 == strcmp($1->code, $3->code)) || intfloat || floatint){
                  char inType[100];
                  if (intfloat || floatint) {
                        strcpy(inType, "float"); // Resultante de int + float ou float + int deve ser float
                  } else {
                        strcpy(inType, $1->code); // Se ambos os tipos são iguais
                  }
                  ex2(&$$, &$1, "%", &$3, inType);
            } else {
                  yyerror(cat("Types ", $1->code, " and ", $3->code, " are incompatible!"));
            }
      }
	| fator {$$ = $1;}
	;

fator : fator '^' base {}
      | ID acesso_array {}
      | endereco acesso_array {}
      | endereco {}
      | base {$$ = $1;}
      ;

expre_logica_par: '(' expre_logica ')' {}
      ;

base : ID {}
      | NUMBER {baseIntNumber(&$$, &$1);}
      | NUMBERFLOAT {baseRealNumber(&$$, &$1);}
      | WORD {baseStringLiteral(&$$, &$1);}
      | TRUE {baseTrue(&$$);}
      | FALSE {baseFalse(&$$);}
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
      int mostrarTabelaDeSimbolos = 0;


      if (argc < 3) {
            printf("Usage: $./compiler input.txt output.txt\nClosing application...\n");
            exit(0);
      }
      
      if(argc == 4) {
            if (strcmp(argv[3], "-t") == 0) {
                  mostrarTabelaDeSimbolos = 1;
            } 
      }

      yyin = fopen(argv[1], "r");
      yyout = fopen(argv[2], "w");

      variablesTable = createSymbolTable(TABLE_SIZE);
	functionsTable = createSymbolTable(TABLE_SIZE);
	typedTable = createSymbolTable(TABLE_SIZE);
	countFuncCallParams = 0;
    
      codigo = yyparse();

      fclose(yyin);
      fclose(yyout);

      if(mostrarTabelaDeSimbolos)	 {
		printf("\n*******************************\n");
		printf("Mostrando tabela de variaveis: \n");
		printf("*******************************\n");
		printTable(variablesTable);
		printf("*******************************\n");
		printf("Mostrando tabela de funcoes: \n");
		printf("*******************************\n");
		printTable(functionsTable);
	}

      return codigo;
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}


void insertFunctionParam( char *paramName, char *paramType){
	int paramId = 0; 
	char strNum[30];

	do {
		sprintf(strNum, "%d", paramId);
		paramId++;
	} while(lookup(functionsTable, cat(strNum,"","","","")));

	insert(functionsTable, cat(strNum,"","","",""), paramName, paramType);
}