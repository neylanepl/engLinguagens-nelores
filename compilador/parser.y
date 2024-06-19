%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./lib/record.h"
#include "./lib/semantics.h"
#include "./lib/hashTable.h"
#include "./lib/stack.h"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;
extern FILE * yyin, * yyout;

char * cat(char *, char *, char *, char *, char *);
SymbolTable *variablesTable;
SymbolTable *functionsTable;
SymbolTable *typedTable;
stack *scopeStack;
int countFuncCallParams;
void insertFunctionParam(vatt *, char *, char *);
char* lookup_type(record *, vatt *temp);

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
%type <rec> condicional else_block retorno iteracao selecao casos caso elementos_array base casoDefault listaCasos
%type <rec> decl_array tamanho_array definicao_struct lista_campos atribuicao_struct expressao_tamanho_array elemento_matriz definicao_enum lista_enum decl_array_atr_tipada decl_array_atr
%type <rec> entrada expre_logica_iterador saida saida_args saida_args_aux comentario_selecao comentario decl_var_atr_tipada decl_var_atr decl_var_ponteiro decl_var_const decl_var entrada_atribuicao
%type <rec> endereco tipo_ponteiro stmts base_case_array expressao_for_inicial parametros_rec parametro acesso_array parametro_com_vazio tipo tipo_array

%start prog

%%
prog : {pushS(scopeStack, "global", "");} stmts subprogs main {
            popS(scopeStack);
            fprintf(yyout, "#include <stdio.h>\n#include <math.h>\n%s\n%s\n%s", $2->code, $3->code, $4->code);
            freeRecord($2);
            freeRecord($3);
            freeRecord($4);
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

main : VOID MAIN '(' args_com_vazio ')' '{' {pushS(scopeStack, "main", "");} bloco '}' {popS(scopeStack);}{
      char *s = cat("int main(", $4->code, "){\n", $8->code,"}");
      freeRecord($4);
      freeRecord($8);
      $$ = createRecord(s, "");
      free(s);
};

tipo_ponteiro: TYPE '*' {
    char pointerType[100];
    snprintf(pointerType, sizeof(pointerType), "%s*", $1);
    $$ = createRecord(pointerType,"");
}
;

ponteiro: '*' ID {}
          ;

endereco: '&' ID {
      vatt *tmp = peekS(scopeStack);
      SymbolInfos *info = lookup(variablesTable, tmp, $2);
      if (info == NULL) {
        yyerror(cat("Cannot use variable ", $2, " before initialization!", "", ""));
      } else {
        char address[100];
        snprintf(address, sizeof(address), "&%s", $2);
        
        char addressType[100];
        snprintf(addressType, sizeof(addressType), "%s*", info->type);
        $$ = createRecord(address, addressType);
    }
}
          ;

tipo_array: TYPE tamanho_array {}
            ;

tipo: TYPE {$$ = createRecord($1,"");}
      | tipo_ponteiro {$$ = $1;}
      | tipo_array {$$ = $1;}
      | ID {
            vatt *tmp = peekS(scopeStack);
            if(lookup(typedTable, tmp, $1) == NULL){
                  yyerror(cat("unknown type ",$1,"","",""));
	      } 
		$$ = createRecord($1,""); 
      }
      ;
 
args : tipo ID   {
            vatt *tmp = peekS(scopeStack);
            insert(variablesTable, cat(tmp->subp, "#", $2,"",""), $2, $1->code);
	      insertFunctionParam(tmp, $2, $1->code);
            argumentoTipoId(&$$, &$2, &$1); 
      }
      | tipo ID ',' args  {
            vatt *tmp = peekS(scopeStack);
            insert(variablesTable, cat(tmp->subp, "#", $2,"",""), $2, $1->code);
	      insertFunctionParam(tmp, $2, $1->code);
            argumentoTipoIdRecusao(&$$, &$2, &$1, &$4); 
      }
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

decl_funcao : FUNCTION tipo ID {pushS(scopeStack, $3, "");} '(' args_com_vazio ')' '{' bloco '}'       {
                        vatt *tmp = peekS(scopeStack);
                        if (lookup(variablesTable, tmp, $3 )) {
                              yyerror(cat("error: redeclaration of function ", $3, "", "", ""));
                        } else {
                              insert(functionsTable, cat(tmp->subp, "#", $3,"",""),"return",$2->code);
                              declaracaoFuncao(&$$, &$3, &$6, &$2->code, &$9);
                              popS(scopeStack);
                        }  
}           
            ;

decl_procedimento : PROCEDURE ID {pushS(scopeStack, $2, "");} '(' args_com_vazio ')' '{' bloco '}'  {
                        vatt *tmp = peekS(scopeStack);
                        if (lookup(variablesTable, tmp, $2)) {
                              yyerror(cat("error: redeclaration of procedure ", $2, "", "", ""));
                        } else {
                              insert(functionsTable, cat(tmp->subp, "#", $2,"",""),"r","void");
                              declaracaoProcedimento(&$$, &$2, &$5, &$8);
                              popS(scopeStack);
                        }  
}                   
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

comando : condicional {$$ = $1;} //palavra fimIF + usar o contador de condicional
      | retorno {$$ = $1;}
      | iteracao {$$ = $1;} 
      | selecao {$$ = $1;}
      | BREAK PV {
            $$ = createRecord("break;\n", "");
      }
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

iteracao : WHILE '(' expre_logica_iterador ')' '{' {pushS(scopeStack, cat("WHILE_",getWhileID(),"","",""), ""); incWhileID();} bloco '}' {
            vatt *tmp = peekS(scopeStack);
            if (strcmp(lookup_type($3, tmp), "bool") == 0){
                  vatt *tmp = peekS(scopeStack);
                  ctrl_b3(&$$, &$3, &$7, cat(tmp->subp,"","","",""));
                  popS(scopeStack);
            } else {
                  yyerror(cat("invalid type of expression ",$3->code," (expected bool, received ",lookup_type($3, tmp),")"));
            }
      }
	     | FOR '(' expressao_for_inicial expre_logica_iterador PV expressao_for_final ')' '{' bloco '}' {}
           ;

expre_logica_iterador: expre_logica {$$ = $1;}
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

caso : CASE base_case_array ':' bloco  PV comentario_selecao  {}
	;

casoDefault : DEFAULT ':' bloco  PV comentario_selecao {}
	       ;

retorno : RETURN PV  {}
        | RETURN expre_logica  PV  {}
        ;

condicional : IF '(' expre_logica_iterador ')' '{' {
            pushS(scopeStack, cat("IF_", getIfID(), "", "", ""), "");
            incIfID();
      } bloco '}' else_block {
            vatt *tmp = peekS(scopeStack);

            if (strcmp(lookup_type($3, tmp), "bool") == 0) {
                  if (!strcmp($9->code, "")) {
                        ifBlock(&$$, &$3, &$7, tmp->subp);
                  } else {
                        ifElseBlock(&$$, &$3, &$7, &$9, tmp->subp);
                  }
            } else {
                  yyerror(cat("invalid type of expression ",$3->code," (expected bool, received ",lookup_type($3, tmp),")"));
            }
            popS(scopeStack);
      }
;

else_block : {$$ = createRecord("", "");}
      | ELSE '{' bloco '}' {$$ = $3;}
      | ELSE condicional {$$ = $2;}
      ;

chamada_funcao : ID {pushS(scopeStack, $1, "");} '(' parametro_com_vazio ')' {
            vatt *tmp = peekS(scopeStack);
            SymbolInfos *foundFuncReturn = lookup(functionsTable, tmp, $1);
            if(foundFuncReturn){
                  char funcType[100];
                  strcpy(funcType, foundFuncReturn->type);
                  record *rcdParam = createRecord($4->code, "");
                  chamadaParamFuncao(&$$, &$1, &rcdParam, funcType);
                  popS(scopeStack);
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

entrada : SCANF '(' WORD ',' ID ')' PV {
            scanfPalavraIdeEndereco(&$$, &$3, &$5);
      }
      | SCANF '(' WORD ',' ID acesso_array ')' PV {}
      | SCANF '(' WORD ',' endereco ')' PV {
            scanfPalavraIdeEndereco(&$$, &$3, &$5->code);
      }
      | SCANF '(' WORD ',' endereco acesso_array ')' PV {}
      | entrada_atribuicao {}
      ;

saida : PRINT '(' saida_args ')' PV {$$ = $3;}
      | PRINTLN '(' saida_args ')' PV {
            char *str = cat($3->code, "printf(\"\\n\");\n", "", "", "");
            $$ = createRecord(str, "");
            free(str);
      }
      ;

saida_args : expre_arit saida_args_aux {
            vatt *tmp = peekS(scopeStack);
            char *type = lookup_type($1, tmp);
            char *str1;

            if (!strcmp(type, "int")) {
                  str1 = cat("printf(\"%d\", ", $1->code, ");\n", "", "");
            } else if (!strcmp(type, "float")) {
                  str1 = cat("printf(\"%f\", ", $1->code, ");\n", "", "");
            } else if (!strcmp(type, "bool")) {
                  str1 = cat("printf((", $1->code, ") ? \"true\" : \"false\");\n", "", "");
            } else if (!strcmp(type, "string")) {
                  str1 = cat("printf(", $1->code,");\n", "", "");
            }

            char *str2 = cat(str1, $2->code, "", "", "");
            $$ = createRecord(str2, "");
            free(str1);
            free(str2);
      }
      ;

saida_args_aux : {$$ = createRecord("", "");}
      | ',' saida_args {$$ = $2;}
      ;

entrada_atribuicao: TYPE ID '=' entrada {}
      | FINAL TYPE ID '=' entrada {}
      | CONST TYPE ID '=' entrada {}
      | ID '=' entrada {}
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
                        vatt *tmp = peekS(scopeStack);
                        if (lookup(variablesTable, tmp, $2)) {
                              yyerror(cat("error: redeclaration of variable ", $2, "", "", ""));
                        } else {
                              insert(variablesTable, cat(tmp->subp, "#", $2,"",""), $2, $1);

                              int intfloat = !strcmp($1, "int") && !strcmp(lookup_type($4, tmp), "int");
                              int floatint = !strcmp($1, "float") && !strcmp(lookup_type($4, tmp), "float");

                              if (strcmp($1, lookup_type($4, tmp)) == 0 || intfloat || floatint) {
                                    record *rcdIdDeclTipada = createRecord($2, "");
                                    init1(&$$, &rcdIdDeclTipada, &$1, &$4);
                              } else {
                                    yyerror(cat("Initialization of ", $1, " from type ", lookup_type($4, tmp), " is incompatible!"));
                              }
                        }  
                  }
                  | TYPE ID MOREISEQUAL expre_logica PV{}
                  | TYPE ID LESSISEQUAL expre_logica PV{}
                  | TYPE ID '=' chamada_funcao PV {}
                  ;

decl_var_atr: ID '=' expre_logica PV {
                        vatt *tmp = peekS(scopeStack);
                        if (!lookup(variablesTable, tmp, $1)) {
                              yyerror(cat("error: nondeclaration of variable ", $1, "", "", ""));
                        } else {
                              char *typeVariable = lookup_variable_type(variablesTable, tmp, $1);
                              record *rcdAtribuicao = createRecord($1, "");
                              int intfloat = !strcmp(typeVariable, "int") && !strcmp(lookup_type($3, tmp), "int");
                              int floatint = !strcmp(typeVariable, "float") && !strcmp(lookup_type($3, tmp), "float");
                              
                              if (strcmp(typeVariable, lookup_type($3, tmp)) == 0 || intfloat || floatint) {
                                    atribuicaoVariavel(&$$, &rcdAtribuicao, &$3);
                              } else {
                                    yyerror(cat("Initialization of ", $1, " from type ", lookup_type($3, tmp), " is incompatible!"));
                              }
                        }  
            }
            | ID '=' ponteiro PV {}
            | ID MOREISEQUAL expre_logica PV {
                        vatt *tmp = peekS(scopeStack);
                        if (!lookup(variablesTable, tmp, $1)) {
                              yyerror(cat("error: nondeclaration of variable ", $1, "", "", ""));
                        } else {
                              char *typeVariable = lookup_variable_type(variablesTable, tmp, $1);
                              record *rcdAtribuicao = createRecord($1, "");

                              int intfloat = !strcmp(typeVariable, "int") && !strcmp(lookup_type($3, tmp), "float");
                              int floatint = !strcmp(typeVariable, "float") && !strcmp(lookup_type($3, tmp), "int");
                              
                              if (strcmp(typeVariable, lookup_type($3, tmp)) == 0 || intfloat || floatint) {
                                    atribuicaoVariavelMaisIgual(&$$, &rcdAtribuicao, &$3);
                              } else {
                                    yyerror(cat("Initialization of ", $1, " from type ", lookup_type($3, tmp), " is incompatible!"));
                              }
                        }  
            }
            | ID LESSISEQUAL expre_logica PV {
                  vatt *tmp = peekS(scopeStack);
                  if (!lookup(variablesTable, tmp, $1)) {
                              yyerror(cat("error: nondeclaration of variable ", $1, "", "", ""));
                        } else {
                              char *typeVariable = lookup_variable_type(variablesTable, tmp, $1);
                              record *rcdAtribuicao = createRecord($1, "");

                              int intfloat = !strcmp(typeVariable, "int") && !strcmp(lookup_type($3, tmp), "float");
                              int floatint = !strcmp(typeVariable, "float") && !strcmp(lookup_type($3, tmp), "int");
                              
                              if (strcmp(typeVariable, lookup_type($3, tmp)) == 0 || intfloat || floatint) {
                                    atribuicaoVariavelMenosIgual(&$$, &rcdAtribuicao, &$3);
                              } else {
                                    yyerror(cat("Initialization of ", $1, " from type ", lookup_type($3, tmp), " is incompatible!"));
                              }
                        }  
            }
            | ID '=' chamada_funcao PV {}
            ;

decl_var: TYPE ID PV {
      vatt *tmp = peekS(scopeStack);
      if (lookup(variablesTable, tmp, $2)) {
            yyerror(cat("error: redeclaration of variable ", $2, "", "", ""));
      }
      insert(variablesTable, cat(tmp->subp, "#", $2,"",""), $2, $1);
      record *rcdIdDeclVar = createRecord($2, ""); 
      dec1(&$$, &rcdIdDeclVar, &$1);
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
               | parametro ',' parametros_rec {
                  char strP[30];
                  sprintf(strP, "%d", countFuncCallParams);
                  vatt *tmp = peekS(scopeStack);
                  char *typeParametro = lookup_variable_type(functionsTable, tmp, cat("p",strP,"","", ""));
                  
                  int intfloat = !strcmp(typeParametro, "int") && !strcmp(lookup_type($1, tmp), "int");
                  int floatint = !strcmp(typeParametro, "float") && !strcmp(lookup_type($1, tmp), "float");

                  if((0 == strcmp(typeParametro, lookup_type($1, tmp))) || intfloat || floatint ){
                        char *str = cat($1->code, ", ", $3->code, "", "");
                        $$ = createRecord(str, "");
                        freeRecord($1);
                        freeRecord($3);
                        free(str);
                  } else {
                        yyerror(cat("Expected type ", typeParametro, " and actual ", lookup_type($1, tmp), " are incompatible!"));
                  }

                  countFuncCallParams++;
                  
               }
               ;

parametro : expre_logica {
            char strP[30];
		sprintf(strP, "%d", countFuncCallParams--);
		vatt *tmp = peekS(scopeStack);
            char *typeParametro = lookup_variable_type(functionsTable, tmp, cat("p",strP,"","", ""));
		
		int intfloat = !strcmp(typeParametro, "int") && !strcmp(lookup_type($1, tmp), "int");
		int floatint = !strcmp(typeParametro, "float") && !strcmp(lookup_type($1, tmp), "float");

		if((0 == strcmp(typeParametro, lookup_type($1, tmp))) || intfloat || floatint ){
			$$ = $1;
		} else {
			yyerror(cat("Expected type ", typeParametro, " and actual ", lookup_type($1, tmp), " are incompatible!"));
		}

		countFuncCallParams++;
}
           | tipo '.' ID {}
           ;

parametro_com_vazio: {$$ = createRecord("","");}
                    | parametros_rec {$$ = $1;}
            ;

expre_logica : expre_logica ANDCIRCUIT expre_logica {} 
             | expre_logica ORCIRCUIT expre_logica {} 
             | expre_logica AND expre_logica {
                  vatt *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        ex2(&$$, &$1, "&&", &$3, "bool");
                  } else {
                        yyerror(cat("Types ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " are incompatible!"));
                  }
             }
             | expre_logica OR expre_logica {
                  vatt *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        ex2(&$$, &$1, "||", &$3, "bool");
                  } else {
                        yyerror(cat("Types ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " are incompatible!"));
                  }
             }
             | expre_logica LESSTHENEQ expre_logica {
                  vatt *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        ex2(&$$, &$1, "<=", &$3, "bool");
                  } else {
                        yyerror(cat("Types ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " are incompatible!"));
                  }
             }
             | expre_logica MORETHENEQ expre_logica {
                  vatt *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        ex2(&$$, &$1, ">=", &$3, "bool");
                  } else {
                        yyerror(cat("Types ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " are incompatible!"));
                  }
             }
             | expre_logica '<' expre_logica {
                  vatt *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        ex2(&$$, &$1, "<", &$3, "bool");
                  } else {
                        yyerror(cat("Types ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " are incompatible!"));
                  }
             }
             | expre_logica '>' expre_logica {
                  vatt *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        ex2(&$$, &$1, ">", &$3, "bool");
                  } else {
                        yyerror(cat("Types ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " are incompatible!"));
                  }
             }
             | expre_logica ISEQUAL expre_logica {
                  vatt *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        ex2(&$$, &$1, "==", &$3, "bool");
                  } else {
                        yyerror(cat("Types ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " are incompatible!"));
                  }
             }
             | expre_logica ISDIFFERENT expre_logica {
                  vatt *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        ex2(&$$, &$1, "!=", &$3, "bool");
                  } else {
                        yyerror(cat("Types ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " are incompatible!"));
                  }
             }
             | '!'  expre_logica {}
             | expre_logica_par {}
             | expre_arit {$$ = $1;}
             ;
               
expre_arit : expre_arit '+' termo {
                  vatt *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        char inType[100];
                        if (intfloat || floatint) {
                              strcpy(inType, "float"); // Resultante de int + float ou float + int deve ser float
                        } else {
                              strcpy(inType, lookup_type($1, tmp)); // Se ambos os tipos são iguais
                        }
                        ex2(&$$, &$1, "+", &$3, inType);
                  } else {
                        yyerror(cat("Types ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " are incompatible!"));
                  }
            }
            | expre_arit '-' termo {
                  vatt *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        char inType[100];
                        if (intfloat || floatint) {
                              strcpy(inType, "float"); // Resultante de int + float ou float + int deve ser float
                        } else {
                              strcpy(inType, lookup_type($1, tmp)); // Se ambos os tipos são iguais
                        }
                        ex2(&$$, &$1, "-", &$3, inType);
                  } else {
                        yyerror(cat("Types ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " are incompatible!"));
                  }
            }
            | ops termo {
                        vatt *tmp = peekS(scopeStack);
                        if(strcmp(lookup_type($2, tmp), "int") == 0 || strcmp(lookup_type($2, tmp), "float") == 0 ){
                              atribuicaoIncreDecre(&$$, &$1->code, &$2->code);
                        } else {
                              yyerror(cat("Types ", lookup_type($2, tmp), "", "", " is not incompatible!"));
                        }                  
            }
            | termo ops { 
                        vatt *tmp = peekS(scopeStack);
                        if(strcmp(lookup_type($1, tmp), "int") == 0 || strcmp(lookup_type($1, tmp), "float") == 0 ){
                              atribuicaoIncreDecre(&$$, &$1->code, &$2->code);
                        } else {
                              yyerror(cat("Types ", lookup_type($1, tmp), "", "", " is not incompatible!"));
                        } 
            }
            | termo {$$ = $1;}
            ;
	    
ops: INCREMENT {$$ = createRecord("++", "");}
     | DECREMENT {$$ = createRecord("--", "");}
     ;

termo: termo '*' fator {
            vatt *tmp = peekS(scopeStack);
            int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
            int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

            if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                  char inType[100];
                  if (intfloat || floatint) {
                        strcpy(inType, "float"); // Resultante de int + float ou float + int deve ser float
                  } else {
                        strcpy(inType, lookup_type($1, tmp)); // Se ambos os tipos são iguais
                  }
                  ex2(&$$, &$1, "*", &$3, inType);
            } else {
                  yyerror(cat("Types ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " are incompatible!"));
            }
      }
	| termo '/' fator {
            vatt *tmp = peekS(scopeStack);
            int number1 = !(strcmp(lookup_type($1, tmp), "int") || !strcmp(lookup_type($1, tmp), "float"));
            int number3 = !(strcmp(lookup_type($3, tmp), "int") || !strcmp(lookup_type($3, tmp), "float"));

            if(number1 && number3){
                  ex2(&$$, &$1, "/", &$3, "float");
            } else {
                  yyerror(cat("Types ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " are incompatible!"));
            }
      }
	| termo '%' fator {}
	| fator {$$ = $1;}
	;

fator : fator '^' base {
            vatt *tmp = peekS(scopeStack);
            int baseInt = !strcmp(lookup_type($1, tmp), "int");
            int baseFloat = !strcmp(lookup_type($1, tmp), "float");
            int expInt = !strcmp(lookup_type($3, tmp), "int");
            int expFloat = !strcmp(lookup_type($3, tmp), "float");

            if((baseInt || baseFloat) && (expInt || expFloat)){
                  char resultType[100];
                  if (baseFloat || expFloat) {
                        strcpy(resultType, "float"); 
                  } else {
                        strcpy(resultType, "int"); 
                  }
                  ex2(&$$, &$1, "^", &$3, resultType);
            } else {
                  yyerror(cat("Types ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " are incompatible for exponentiation!"));
            }

}
      | ID acesso_array {}
      | endereco acesso_array {}
      | endereco {$$ = $1;}
      | base {$$ = $1;}
      ;

expre_logica_par: '(' expre_logica ')' {}
      ;

base : ID {baseID(&$$, &$1);}
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
      scopeStack = newStack();
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


void insertFunctionParam(vatt *tmp, char *paramName, char *paramType){
	int paramId = 0; 
	char strNum[30];

	do {
		sprintf(strNum, "%d", paramId);
		paramId++;
	} while(lookup(functionsTable, tmp, cat(tmp->subp,"#p",strNum,"","")));

	insert(functionsTable, cat(tmp->subp,"#p",strNum,"",""), paramName, paramType);
}

char* lookup_type(record *r, vatt *tmp) {
	char* type = r->opt1;
	if (!strcmp(type, "id")) {
		SymbolInfos *info = lookup(variablesTable, tmp, r->code);
		if (info == NULL) {
                  yyerror(cat("Cannot use variable ", r->code, " before initialization!", "", ""));
		} else {
                  return info->type;
            }
	} else {
            return r->opt1;
      }
}