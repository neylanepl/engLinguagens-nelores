
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
SymbolTable *funcInfo;
stack *scopeStack;
int countFuncCallParams;
int countFuncArgs;
void insertFunctionParam(stackElement *, char *, char *);
char* lookup_type(record *, stackElement *temp);

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
%token WHILE IF ELSE MAIN VOID
%token FUNCTION
%token RETURN PRINT PRINTLN INPUT
%token AND OR  
%token LESSTHENEQ MORETHENEQ ISEQUAL ISDIFFERENT PV
%token PROCEDURE TRUE FALSE DECREMENT INCREMENT MOREISEQUAL LESSISEQUAL
%left OR 
%left AND 
%left LESSTHENEQ MORETHENEQ '<' '>' ISEQUAL ISDIFFERENT
%left '+' '-'
%left '*' '/' '%'
%right '^'
%nonassoc UMINUS


%type <rec> decl_vars decl_variavel expre_logica expre_arit termo fator chamada_funcao acesso_ponteiro
%type <rec> ops main args subprogs subprog decl_funcao decl_procedimento bloco comando args_com_vazio 
%type <rec> condicional else_block retorno iteracao elementos_array base
%type <rec> decl_array tamanho_array expressao_tamanho_array elemento_matriz decl_array_atr
%type <rec> entrada expre_logica_iterador saida saida_args saida_args_aux decl_atr atr decl
%type <rec> endereco stmts base_case_array  parametros_rec parametro acesso_array parametro_com_vazio tipo tipo_array

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
      ;

main : VOID MAIN '(' args_com_vazio ')' '{' {pushS(scopeStack, "main", "");} bloco '}' {popS(scopeStack);}{
      char *s = cat("int main(", $4->code, "){\n", $8->code,"}");
      freeRecord($4);
      freeRecord($8);
      $$ = createRecord(s, "");
      free(s);
};

endereco: '&' ID {
      stackElement *tmp = peekS(scopeStack);
      SymbolInfos *info = lookup(variablesTable, tmp, $2);
      if (info == NULL) {
        yyerror(cat("Erro: Não pode usar variavel", $2, " antes da inicialização!", "", ""));
        exit(1);
      } else {
        char address[100];
        snprintf(address, sizeof(address), "&%s", $2);
        
        char addressType[100];
        snprintf(addressType, sizeof(addressType), "%s*", info->type);
        $$ = createRecord(address, addressType);
    }
}
          ;

tipo_array: TYPE tamanho_array {
                  char tamanhoArray[100];
                  snprintf(tamanhoArray, sizeof(tamanhoArray), "%s %s", $1, $2->code);
                  freeRecord($2);
                  $$ = createRecord(tamanhoArray,"");    
            }
            ;

tipo: TYPE {$$ = createRecord($1,"");}
      | tipo '*' {
            char *s = cat($1->code, "*", "", "", "");
            $$ = createRecord(s, "");
            freeRecord($1);
            free(s);
      }
      ;
 
args : tipo ID   {
            stackElement *tmp = peekS(scopeStack);
            insert(variablesTable, cat(tmp->subp, "#", $2,"",""), $2, $1->code);
	      insertFunctionParam(tmp, $2, $1->code);
            argumentoTipoId(&$$, &$2, &$1);
            countFuncArgs++;
      }
      | args ',' tipo ID  {
            stackElement *tmp = peekS(scopeStack);
            insert(variablesTable, cat(tmp->subp, "#", $4,"",""), $4, $3->code);
	      insertFunctionParam(tmp, $4, $3->code);
            argumentoTipoIdRecusao(&$$, &$4, &$3, &$1);
            countFuncArgs++; 
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

decl_funcao : FUNCTION tipo ID {pushS(scopeStack, $3, "");} '(' args_com_vazio ')' {
      stackElement *tmp = peekBelowTop(scopeStack);
       if (lookup(functionsTable, tmp, $3 )) {
            yyerror(cat("Erro: redeclaração de função ", $3, "", "", ""));
            exit(1);
      } else {
            insert(functionsTable, cat(tmp->subp, "#", $3,"",""),"return",$2->code);
            insertFunction(funcInfo, cat(peekS(scopeStack)->subp, "#", $3,"",""), "return", $2->code, countFuncArgs);
      }
} '{' bloco '}'       {                       
      declaracaoFuncao(&$$, &$3, &$6, &$2->code, &$10);
      popS(scopeStack);
      countFuncArgs = 0;
}           
            ;

decl_procedimento : PROCEDURE ID {pushS(scopeStack, $2, "");} '(' args_com_vazio ')' {
      stackElement *tmp = peekBelowTop(scopeStack);
      if (lookup(functionsTable, tmp, $2)) {
            yyerror(cat("Erro: redeclaração de procedimento ", $2, "", "", ""));
            exit(1);
      } else {
            insert(functionsTable, cat(tmp->subp, "#", $2,"",""),"r","void");
            insertFunction(funcInfo, cat(peekS(scopeStack)->subp, "#", $2,"",""), "r", "void", countFuncArgs);
      }
}'{' bloco '}'  {
      declaracaoProcedimento(&$$, &$2, &$5, &$9);
      popS(scopeStack);
      countFuncArgs = 0;
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
      | decl_array bloco  {
            char *declArray = cat($1->code,$2->code,"","","");
            freeRecord($1);
            freeRecord($2);
            $$ = createRecord(declArray, "");
            free(declArray);
      }
      | comando bloco {
            char *declComando = cat($1->code,$2->code,"","","");
            freeRecord($1);
            freeRecord($2);
            $$ = createRecord(declComando, "");
            free(declComando);
      } 
      | ID ops PV bloco {
            stackElement *tmp = peekS(scopeStack);
             if (!lookup(variablesTable, tmp, $1)) {
                  yyerror(cat("Erro: variavel não declarada ", $1, "", "", ""));
                  exit(1);
            } else {
                  record *rcdAtribuicao = createRecord($1, "");    
                  char *typeVariable = lookup_variable_type(variablesTable, tmp, $1);  
                              
                  if(strcmp(typeVariable, "int") == 0 || strcmp(typeVariable, "float") == 0 ){       
                        char *declIncremento = cat(rcdAtribuicao->code,$2->code,";",$4->code,"\n");
                        freeRecord($2);
                        $$ = createRecord(declIncremento, "");
                        free(declIncremento);
                  } else {
                        yyerror(cat("Erro: Inicialização de ", $1, " from type ", typeVariable, " não é compatível!"));
                        exit(1);
                  }
                  free(typeVariable);
            }  
      }
      | ops ID PV bloco {
            stackElement *tmp = peekS(scopeStack);
            if (!lookup(variablesTable, tmp, $2)) {
                  yyerror(cat("Erro: variavel não declarada ", $2, "", "", ""));
                  exit(1);
            } else {
                  record *rcdAtribuicao = createRecord($2, "");    
                  char *typeVariable = lookup_variable_type(variablesTable, tmp, $2);  
                              
                  if(strcmp(typeVariable, "int") == 0 || strcmp(typeVariable, "float") == 0 ){       
                        char *declIncremento = cat($1->code, rcdAtribuicao->code, ";",$4->code,"\n");
                        freeRecord($1);
                        $$ = createRecord(declIncremento, "");
                        free(declIncremento);
                  } else {
                        yyerror(cat("Erro: Inicialização de ", $2, " from type ", typeVariable, " não é compatível!"));
                        exit(1);
                  }
                  free(typeVariable);
            }  
      }   
      ;

comando : {pushS(scopeStack, cat("IFZAO_", getIfID(), "", "", ""), "0");} condicional 
{
char *str3 = cat($2->code, "endif",peekS(scopeStack)->subp, ":\n\n", "");
	$$ = createRecord(str3, "");
      freeRecord($2);
      free(str3);
popS(scopeStack);}
      | iteracao {$$ = $1;} 
      | chamada_funcao PV {
            char *s = cat($1->code,";\n","","","");
            freeRecord($1);
            $$ = createRecord(s, "");
            free(s);
      } 
      | entrada {$$ = $1;}
      | saida {$$ = $1;}
      | retorno {$$ = $1;}
      ;

iteracao : WHILE '(' expre_logica_iterador ')' '{' {pushS(scopeStack, cat("WHILE_",getWhileID(),"","",""), ""); incWhileID();} bloco '}' {
            stackElement *tmp = peekS(scopeStack);
            if (strcmp(lookup_type($3, tmp), "bool") == 0){
                  stackElement *tmp = peekS(scopeStack);
                  iteradorWhile(&$$, &$3, &$7, cat(tmp->subp,"","","",""));
                  popS(scopeStack);
            } else {
                  yyerror(cat("Erro: tipo da expressão inválido ",$3->code," (esperava bool, recebido ",lookup_type($3, tmp),")"));
                  exit(1);
            }
      }
           ;

expre_logica_iterador: expre_logica {$$ = $1;}
                    ;
retorno : RETURN PV  {$$ = createRecord("return;\n", "");}
        | RETURN expre_logica  PV  {
            stackElement *tmp = peekS(scopeStack);
            SymbolInfos *foundFuncReturn = lookup(functionsTable, tmp, tmp->subp);
            if(foundFuncReturn != NULL){
			char funcType[100];
			strcpy(funcType, foundFuncReturn->type);
					
			if(0 == strcmp(funcType, lookup_type($2, tmp))){
				char *str = cat("return ", ($2)->code, ";\n", "", "");
                        $$ = createRecord(str, "");
                        freeRecord($2);
                        free(str);
			} else {
				yyerror(cat("Erro: função com o retorno do tipo ", funcType, " e o retorno ", lookup_type($2, tmp), " da expressão são incompatíveis."));
                        exit(1);
			}
		} else {
			yyerror("Erro: retorno de função não encontrado");
                  exit(1);
		}
            
        }
        ;

condicional : IF '(' expre_logica_iterador ')' '{' {
            pushS(scopeStack, cat(peekS(scopeStack)->subp, "IF_", getIfID(), "", ""), "");
            popS(scopeStack);
            incIfID(); 
      } bloco '}' else_block {
            stackElement *tmp = peekS(scopeStack);

            if (strcmp(lookup_type($3, tmp), "bool") == 0) {
                  if (!strcmp($9->code, "")) {
                        ifBlock(&$$, &$3, &$7, tmp->subp);
                  } else {
                        ifElseBlock(&$$, &$3, &$7, &$9, tmp->subp, tmp->type);
	                  int nextIf = atoi(tmp->type) + 1;
	                  int length = snprintf( NULL, 0, "%d", nextIf );
	                  char* nextIfStr= malloc( length + 1 );
	                  snprintf( nextIfStr, length + 1, "%d", nextIf );
                        tmp->type = nextIfStr;
                  }
            } else {
                  yyerror(cat("Erro: tipo da expressão inválido ",$3->code," (esperava bool, recebido ",lookup_type($3, tmp),")"));
                  exit(1);
            }
            
      }
;

else_block : {$$ = createRecord("", "");}
      | ELSE '{' bloco '}' {$$ = $3;}
      | ELSE condicional {$$ = $2;}
      ;

chamada_funcao : ID {pushS(scopeStack, $1, "");} '(' parametro_com_vazio ')' {
            stackElement *tmp = peekS(scopeStack);
            SymbolInfos *foundFuncReturn = lookup(functionsTable, tmp, $1);
            if(foundFuncReturn){
                  FunctionInfos *funcInfoaux = lookupFunction(funcInfo, cat(tmp->subp, "#", $1, "", ""));
                  if (funcInfoaux->numParams == countFuncCallParams) {
                        char funcType[100];
                        strcpy(funcType, foundFuncReturn->type);
                        record *rcdParam = createRecord($4->code, "");
                        chamadaParamFuncao(&$$, &$1, &rcdParam, funcType);
                        popS(scopeStack);
                        countFuncCallParams = 0;
                  }
                  else{
                        fprintf(stderr, "Erro: Função '%s' esperava %d argumentos, mas %d foram passados.\n", $1, funcInfoaux->numParams, countFuncCallParams);
                        exit(1);
                  }
            } else {
                  yyerror(cat("Erro: função indefinida ",$1,"","",""));
                  exit(1);
            }
      }
               ;

entrada : INPUT '(' endereco ')' PV {
            stackElement *tmp = peekS(scopeStack);
            char *addressType = lookup_type($3, tmp);
            char *type = strtok(addressType, "*");
            
            char *str;
            if (!strcmp(type, "int")) {
                  str = cat("scanf(\"%d\", ", $3->code, ");\n", "", "");
            } else if (!strcmp(type, "float")) {
                  str = cat("scanf(\"%f\", ", $3->code, ");\n", "", "");
            } else if (!strcmp(type, "bool")) {
                  str = cat("scanf(\"%d\", ", $3->code, ");\n", "", "");
            } else {
                  yyerror(cat("Erro: não é possivel usar o tipo ", type, " para entrada.", "", ""));
            }

            $$ = createRecord(str, "");
            free(str);
            free(addressType);
      }
      | INPUT '(' endereco acesso_array ')' PV {
            stackElement *tmp = peekS(scopeStack);
            char *addressType = lookup_type($3, tmp);
            char *arrayType = strtok(addressType, "*");
            char *type = strtok(arrayType, " ");
            
            char *str;
            if (!strcmp(type, "int")) {
                  str = cat("scanf(\"%d\", ", $3->code, $4->code, ");\n", "");
            } else if (!strcmp(type, "float")) {
                  str = cat("scanf(\"%f\", ", $3->code, $4->code, ");\n", "");
            } else if (!strcmp(type, "bool")) {
                  str = cat("scanf(\"%d\", ", $3->code, $4->code, ");\n", "");
            } else {
                  yyerror(cat("Erro: não é possivel usar o tipo ", type, " para entrada.", "", ""));
            }

            $$ = createRecord(str, "");
            free(str);
            free(addressType);
      }
      ;

saida : PRINT '(' saida_args ')' PV {$$ = $3;}
      | PRINTLN '(' saida_args ')' PV {
            char *str = cat($3->code, "printf(\"\\n\");\n", "", "", "");
            $$ = createRecord(str, "");
            free(str);
      }
      ;

saida_args : expre_arit saida_args_aux {
            stackElement *tmp = peekS(scopeStack);
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
            } else {
                  yyerror(cat("Erro: não é possivel usar o tipo ", type, " para saída.", "", ""));
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

decl_vars : decl_variavel  {$$ = $1;}
            | decl_array {$$ = $1;}
            ;

decl_array : tipo_array ID '=' '[' elementos_array ']' PV {}
            | tipo_array ID '='  expre_logica  PV {}
            | ID '=' '['  elementos_array  ']' PV {
                 
            }
            | tipo_array ID PV {
                 stackElement *tmp = peekS(scopeStack);
                  if (lookup(variablesTable, tmp, $2)) {
                        yyerror(cat("Erro: redeclaração de variavel ", $2, "", "", ""));
                        exit(1);
                  }
                  char *arrayType = $1->code;
                  insert(variablesTable, cat(tmp->subp, "#", $2,"",""), $2, arrayType);

                  record *rcdArrayAtribuicao = createRecord($2, "");
                  arraySemAtribuicao(&$$, &$1, &rcdArrayAtribuicao, arrayType);
                   
            } 
            | decl_array_atr {$$ = $1;}
            ;

decl_array_atr: ID tamanho_array '=' expre_logica PV {
                  stackElement *tmp = peekS(scopeStack);
                  if (!lookup(variablesTable, tmp, $1)) {
                        yyerror(cat("Erro: variavel não declarada ", $1, "", "", ""));
                        exit(1);
                  } else {
                        char *typeVariable = lookup_variable_type(variablesTable, tmp, $1);
                        char *typeSplited = strtok(typeVariable, " ");
                        record *rcdArrayAtribuicao = createRecord($1, "");
                        int intfloat = !strcmp(typeSplited, "int") && !strcmp(lookup_type($4, tmp), "int");
                        int floatint = !strcmp(typeSplited, "float") && !strcmp(lookup_type($4, tmp), "float");  
                        if (strcmp(typeSplited, lookup_type($4, tmp)) == 0 || intfloat || floatint) {
                              atribuicaoArrayVariavel(&$$, &rcdArrayAtribuicao, &$2, &$4);
                        } else {
                              yyerror(cat("Erro: Inicialização of ", $1, " pelo tipo ", lookup_type($4, tmp), " é incompatível!"));
                              exit(1);
                        }
                       
                  }  
            
            }
            | ID tamanho_array MOREISEQUAL expre_logica PV {
                  stackElement *tmp = peekS(scopeStack);
                  if (!lookup(variablesTable, tmp, $1)) {
                        yyerror(cat("Erro: variavel não declarada ", $1, "", "", ""));
                        exit(1);
                  } else {
                        char *typeVariable = lookup_variable_type(variablesTable, tmp, $1);
                        char *typeSplited = strtok(typeVariable, " ");
                        record *rcdArrayAtribuicao = createRecord($1, "");
                        int intfloat = !strcmp(typeSplited, "int") && !strcmp(lookup_type($4, tmp), "int");
                        int floatint = !strcmp(typeSplited, "float") && !strcmp(lookup_type($4, tmp), "float");
                              
                        if (strcmp(typeSplited, lookup_type($4, tmp)) == 0 || intfloat || floatint) {
                              atribuicaoArrayMoreEqualVariavel(&$$, &rcdArrayAtribuicao, &$2, &$4);
                        } else {
                              yyerror(cat("Erro: Inicialização de ", $1, " pelo tipo ", lookup_type($4, tmp), " é incompatível!"));
                              exit(1);
                        }
                       
                  }  
            }
            | ID tamanho_array LESSISEQUAL expre_logica PV {
                  stackElement *tmp = peekS(scopeStack);
                  if (!lookup(variablesTable, tmp, $1)) {
                        yyerror(cat("Erro: variavel não declarada ", $1, "", "", ""));
                        exit(1);
                  } else {
                        char *typeVariable = lookup_variable_type(variablesTable, tmp, $1);
                        char *typeSplited = strtok(typeVariable, " ");
                        record *rcdArrayAtribuicao = createRecord($1, "");
                        int intfloat = !strcmp(typeSplited, "int") && !strcmp(lookup_type($4, tmp), "int");
                        int floatint = !strcmp(typeSplited, "float") && !strcmp(lookup_type($4, tmp), "float");
                              
                        if (strcmp(typeSplited, lookup_type($4, tmp)) == 0 || intfloat || floatint) {
                              atribuicaoArrayMinusEqualVariavel(&$$, &rcdArrayAtribuicao, &$2, &$4);
                        } else {
                              yyerror(cat("Erro: Inicialização de ", $1, " pelo tipo ", lookup_type($4, tmp), " é incompatível!"));
                              exit(1);
                        }
                       
                  }  
            }
            ;

tamanho_array: '[' expressao_tamanho_array ']'  {
                  stackElement *tmp = peekS(scopeStack);
                  if(0 == strcmp(lookup_type($2, tmp), "int")){
                        char *tamanhoArray = cat("[",$2->code,"]","","");
                        $$ = createRecord(tamanhoArray, "");
                        free(tamanhoArray);
                        freeRecord($2);
                  } else {
                        yyerror(cat("Erro: Tipos ", lookup_type($2, tmp), " não são compatíveis!", "", ""));
                        exit(1);
                  }
                 
             }
             | '[' expressao_tamanho_array ']' tamanho_array {
                  char *tamanhoArray = cat("[", $2->code, "]", $4->code, "");
                  freeRecord($2);
                  freeRecord($4);
                  $$ = createRecord(tamanhoArray, "");
                  free(tamanhoArray);
             }
             ;

expressao_tamanho_array:  ID {baseID(&$$, &$1);}
                         | NUMBER {baseIntNumber(&$$, &$1);}
                         ;

elemento_matriz:  '[' elementos_array ']' {}
                  | '[' elementos_array ']' ',' elemento_matriz {}
                  ;

elementos_array :  base_case_array {}
                  | base_case_array ',' elementos_array {}
                  | elemento_matriz {}
                  ;

acesso_array: '[' expre_arit ']'  {
                  stackElement *tmp = peekS(scopeStack);
                  if(0 == strcmp(lookup_type($2, tmp), "int")){
                        char *tamanhoArray = cat("[",$2->code,"]","","");
                        $$ = createRecord(tamanhoArray, "");
                        free(tamanhoArray);
                        freeRecord($2);
                  } else {
                        yyerror(cat("Erro: Tipos ", lookup_type($2, tmp), "  não são compatíveis!", "", ""));
                         exit(1);
                  }
            }
            | '[' expre_arit ']' acesso_array {
                  char *tamanhoArray = cat("[", $2->code, "]", $4->code, "");
                  freeRecord($2);
                  freeRecord($4);
                  $$ = createRecord(tamanhoArray, "");
                  free(tamanhoArray);
            }
            ;

decl_variavel : decl_atr {$$ = $1;}
              | atr {$$ = $1;}
              | decl {$$ = $1;}
              ;

decl_atr: tipo ID '=' expre_logica PV{
                        stackElement *tmp = peekS(scopeStack);
                        if (lookup(variablesTable, tmp, $2)) {
                              yyerror(cat("Erro: redeclaração de variavel ", $2, "", "", ""));
                              exit(1);
                        } else {
                              insert(variablesTable, cat(tmp->subp, "#", $2,"",""), $2, $1->code);

                              if (strcmp($1->code, lookup_type($4, tmp)) == 0) {
                                    record *rcdIdDeclTipada = createRecord($2, "");
                                    atribuicaoVariavelTipada(&$$, &rcdIdDeclTipada, &$1->code, &$4);
                              } else {
                                    yyerror(cat("Erro: Inicialização de ", $1->code, " pelo tipo ", lookup_type($4, tmp), " é incompatível!"));
                                    exit(1);
                              }
                        }  
                  }
                  ;

atr: ID '=' expre_logica PV {
                        stackElement *tmp = peekS(scopeStack);
                        if (!lookup(variablesTable, tmp, $1)) {
                              yyerror(cat("Erro: variavel não declarada ", $1, "", "", ""));
                               exit(1);
                        } else {
                              char *typeVariable = lookup_variable_type(variablesTable, tmp, $1);
                              record *rcdAtribuicao = createRecord($1, "");
                              
                              if (strcmp(typeVariable, lookup_type($3, tmp)) == 0) {
                                    atribuicaoVariavel(&$$, &rcdAtribuicao, &$3);
                              } else {
                                    yyerror(cat("Erro: Inicialização de ", $1, " pelo tipo ", lookup_type($3, tmp), " é incompatível!"));
                                     exit(1);
                              }
                              free(typeVariable);
                        }  
            }
            | acesso_ponteiro '=' expre_logica PV {
                  stackElement *tmp = peekS(scopeStack);
                  char *ponteiro = strdup($1->code);
                  char *varName = strtok(ponteiro, "*");

                  printf("----- %s -----\n", varName);

                  if (!lookup(variablesTable, tmp, varName)) {
                        yyerror(cat("Erro: variavel não declarada ", varName, "", "", ""));
                              exit(0);
                  } else {
                        char *type = lookup_type($1, tmp);

                        printf("----- %s -----\n", type);

                        record *rcdAtribuicao = createRecord($1->code, "");
                        
                        if (strcmp(type, lookup_type($3, tmp)) == 0) {
                              atribuicaoVariavel(&$$, &rcdAtribuicao, &$3);
                        } else {
                              yyerror(cat("Erro: Inicialização de ", varName, " pelo tipo ", lookup_type($3, tmp), " é incompatível!"));
                                    exit(0);
                        }
                        free(type);
                  }  
                  free(ponteiro);
            }
            | ID MOREISEQUAL expre_logica PV {
                        stackElement *tmp = peekS(scopeStack);
                        if (!lookup(variablesTable, tmp, $1)) {
                              yyerror(cat("Erro: variavel não declarada ", $1, "", "", ""));
                              exit(1);
                        } else {
                              char *typeVariable = lookup_variable_type(variablesTable, tmp, $1);
                              record *rcdAtribuicao = createRecord($1, "");

                              int intfloat = !strcmp(typeVariable, "int") && !strcmp(lookup_type($3, tmp), "float");
                              int floatint = !strcmp(typeVariable, "float") && !strcmp(lookup_type($3, tmp), "int");
                              
                              if (strcmp(typeVariable, lookup_type($3, tmp)) == 0 || intfloat || floatint) {
                                    atribuicaoVariavelMaisIgual(&$$, &rcdAtribuicao, &$3);
                              } else {
                                    yyerror(cat("Erro: Inicialização de ", $1, "  pelo tipo ", lookup_type($3, tmp), " é incompatível!"));
                                      exit(1);
                              }
                              free(typeVariable);
                        }  
            }
            | ID LESSISEQUAL expre_logica PV {
                  stackElement *tmp = peekS(scopeStack);
                  if (!lookup(variablesTable, tmp, $1)) {
                              yyerror(cat("Erro: variavel não declarada ", $1, "", "", ""));
                                exit(1);
                        } else {
                              char *typeVariable = lookup_variable_type(variablesTable, tmp, $1);
                              record *rcdAtribuicao = createRecord($1, "");

                              int intfloat = !strcmp(typeVariable, "int") && !strcmp(lookup_type($3, tmp), "float");
                              int floatint = !strcmp(typeVariable, "float") && !strcmp(lookup_type($3, tmp), "int");
                              
                              if (strcmp(typeVariable, lookup_type($3, tmp)) == 0 || intfloat || floatint) {
                                    atribuicaoVariavelMenosIgual(&$$, &rcdAtribuicao, &$3);
                              } else {
                                    yyerror(cat("Erro: Inicialização de ", $1, " pelo tipo ", lookup_type($3, tmp), " é incompatível!"));
                                    exit(1);
                              }
                              free(typeVariable);
                        }  
            }
            ;

decl: tipo ID PV {
      stackElement *tmp = peekS(scopeStack);
      if (lookup(variablesTable, tmp, $2)) {
            yyerror(cat("Erro: redeclaração de variavel ", $2, "", "", ""));
            exit(1);
      }
      insert(variablesTable, cat(tmp->subp, "#", $2,"",""), $2, $1->code);
      record *rcdIdDeclVar = createRecord($2, ""); 
      declaracaoVariavelTipada(&$$, &rcdIdDeclVar, &$1->code);
};
      
parametros_rec : parametro {$$ = $1;}
      | parametro ',' parametros_rec {
            char *str = cat($1->code, ", ", $3->code, "", "");
            $$ = createRecord(str, "");
            freeRecord($1);
            freeRecord($3);
            free(str);
                  
                  
      }
      ;

parametro : expre_logica {
            char strP[30];
		sprintf(strP, "%d", countFuncCallParams);
		stackElement *tmp = peekS(scopeStack);
            SymbolInfos *foundFuncReturn = lookup(functionsTable, tmp, tmp->subp);
            
            if(foundFuncReturn){
                  char *typeParametro = lookup_variable_type(functionsTable, tmp, cat("p",strP,"","", ""));
                  if(typeParametro){
                        int intfloat = !strcmp(typeParametro, "int") && !strcmp(lookup_type($1, tmp), "int");
                        int floatint = !strcmp(typeParametro, "float") && !strcmp(lookup_type($1, tmp), "float");

                        printf("===== %s %s %s =====\n", $1->code, lookup_type($1, tmp), typeParametro);

                        if((0 == strcmp(typeParametro, lookup_type($1, tmp))) || intfloat || floatint ){
                              $$ = $1;
                        } else {
                              yyerror(cat("Erro: Tipo esperado ", typeParametro, " e atual ", lookup_type($1, tmp), " são incompatíveis!"));
                              exit(1);
                        }

                        countFuncCallParams++;
                   }else {
                        yyerror(cat("Erro: Não existe função ",tmp->subp," definida com esses parâmetros","",""));
                        exit(1);
                  }
            }else {
                  yyerror(cat("Erro: Não existe função ",tmp->subp," definida.","",""));
                  exit(1);
            }
            
		
}
           ;

parametro_com_vazio: {$$ = createRecord("","");}
                    | parametros_rec {$$ = $1;}
            ;

expre_logica : expre_logica AND expre_logica {
                  stackElement *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        expressaoAritmetica(&$$, &$1, "&&", &$3, "bool");
                  } else {
                        yyerror(cat("Erro: Tipos ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " são incompatíveis!"));
                        exit(1);
                  }
             }
             | expre_logica OR expre_logica {
                  stackElement *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        expressaoAritmetica(&$$, &$1, "||", &$3, "bool");
                  } else {
                        yyerror(cat("Erro: Tipos ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " são incompatíveis!"));
                        exit(1);
                  }
             }
             | expre_logica LESSTHENEQ expre_logica {
                  stackElement *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        expressaoAritmetica(&$$, &$1, "<=", &$3, "bool");
                  } else {
                        yyerror(cat("Erro: Tipos ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " são incompatíveis!"));
                        exit(1);
                  }
             }
             | expre_logica MORETHENEQ expre_logica {
                  stackElement *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        expressaoAritmetica(&$$, &$1, ">=", &$3, "bool");
                  } else {
                        yyerror(cat("Erro: Tipos ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " são incompatíveis!"));
                        exit(1);
                  }
             }
             | expre_logica '<' expre_logica {
                  stackElement *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        expressaoAritmetica(&$$, &$1, "<", &$3, "bool");
                  } else {
                        yyerror(cat("Erro: Tipos ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " são incompatíveis!"));
                          exit(1);
                  }
             }
             | expre_logica '>' expre_logica {
                  stackElement *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        expressaoAritmetica(&$$, &$1, ">", &$3, "bool");
                  } else {
                        yyerror(cat("Erro: Tipos ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " são incompatíveis!"));
                          exit(1);
                  }
             }
             | expre_logica ISEQUAL expre_logica {
                  stackElement *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        expressaoAritmetica(&$$, &$1, "==", &$3, "bool");
                  } else {
                        yyerror(cat("Erro: Tipos ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " são incompatíveis!"));
                          exit(1);
                  }
             }
             | expre_logica ISDIFFERENT expre_logica {
                  stackElement *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        expressaoAritmetica(&$$, &$1, "!=", &$3, "bool");
                  } else {
                        yyerror(cat("Erro: Tipos ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " são incompatíveis!"));
                          exit(1);
                  }
             }
             | expre_arit {$$ = $1;}
             ;
               
expre_arit : expre_arit '+' termo {
                  stackElement *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        char inType[100];
                        if (intfloat || floatint) {
                              strcpy(inType, "float"); // Resultante de int + float ou float + int deve ser float
                        } else {
                              strcpy(inType, lookup_type($1, tmp)); // Se ambos os tipos são iguais
                        }
                        expressaoAritmetica(&$$, &$1, "+", &$3, inType);
                  } else {
                        yyerror(cat("Erro: Tipos ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " são incompatíveis!"));
                          exit(1);
                  }
            }
            | expre_arit '-' termo {
                  stackElement *tmp = peekS(scopeStack);
                  int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
                  int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

                  if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                        char inType[100];
                        if (intfloat || floatint) {
                              strcpy(inType, "float"); // Resultante de int + float ou float + int deve ser float
                        } else {
                              strcpy(inType, lookup_type($1, tmp)); // Se ambos os tipos são iguais
                        }
                        expressaoAritmetica(&$$, &$1, "-", &$3, inType);
                  } else {
                        yyerror(cat("Erro: Tipos ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " são incompatíveis!"));
                          exit(1);
                  }
            }
            | ops termo {
                        stackElement *tmp = peekS(scopeStack);
                        if(strcmp(lookup_type($2, tmp), "int") == 0 || strcmp(lookup_type($2, tmp), "float") == 0 ){
                              atribuicaoIncreDecre(&$$, &$1->code, &$2->code);
                        } else {
                              yyerror(cat("Erro: Tipo ", lookup_type($2, tmp), "", "", " não é compatível!"));
                                exit(1);
                        }                  
            }
            | termo ops { 
                        stackElement *tmp = peekS(scopeStack);
                        if(strcmp(lookup_type($1, tmp), "int") == 0 || strcmp(lookup_type($1, tmp), "float") == 0 ){
                              atribuicaoIncreDecre(&$$, &$1->code, &$2->code);
                        } else {
                              yyerror(cat("Erro: Tipo ", lookup_type($1, tmp), "", "", " não é compatível!"));
                              exit(1);
                        } 
            }
            | termo {$$ = $1;}
            ;
	    
ops: INCREMENT {$$ = createRecord("++", "");}
     | DECREMENT {$$ = createRecord("--", "");}
     ;

termo: termo '*' fator {
            stackElement *tmp = peekS(scopeStack);
            int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
            int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

            if((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint){
                  char inType[100];
                  if (intfloat || floatint) {
                        strcpy(inType, "float"); // Resultante de int + float ou float + int deve ser float
                  } else {
                        strcpy(inType, lookup_type($1, tmp)); // Se ambos os tipos são iguais
                  }
                  expressaoAritmetica(&$$, &$1, "*", &$3, inType);
            } else {
                  yyerror(cat("Erro: Tipos ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " não são compatíveis!"));
                  exit(1);
            }
      }
	| termo '/' fator {
            stackElement *tmp = peekS(scopeStack);
            int number1 = !(strcmp(lookup_type($1, tmp), "int") || !strcmp(lookup_type($1, tmp), "float"));
            int number3 = !(strcmp(lookup_type($3, tmp), "int") || !strcmp(lookup_type($3, tmp), "float"));

            if(number1 && number3){
                  expressaoAritmetica(&$$, &$1, "/", &$3, "float");
            } else {
                  yyerror(cat("Erro: Tipos ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " não são compatíveis!"));
                  exit(1);
            }
      } 
      | termo '%' fator {
            stackElement *tmp = peekS(scopeStack);
            int intint = !strcmp(lookup_type($1, tmp), "int") && !strcmp(lookup_type($3, tmp), "int");
            int intfloat = !(strcmp(lookup_type($1, tmp), "int") || strcmp(lookup_type($3, tmp), "float"));
            int floatint = !(strcmp(lookup_type($1, tmp), "float") || strcmp(lookup_type($3, tmp), "int"));

            if (intint) {
                  expressaoAritmetica(&$$, &$1, "%", &$3, "int");
            } else if ((0 == strcmp(lookup_type($1, tmp), lookup_type($3, tmp))) || intfloat || floatint) {
                  expressaoAritmetica(&$$, &$1, "%", &$3, "float");
            } else {
                  yyerror(cat("Erro: Tipos ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " não são compatíveis!"));
                  exit(0);
            }
      } 
	| fator {$$ = $1;}
	;

fator : fator '^' base {
            stackElement *tmp = peekS(scopeStack);
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
                  expressaoAritmetica(&$$, &$1, "^", &$3, resultType);
            } else {
                  yyerror(cat("Erro: Tipos ", lookup_type($1, tmp), " and ", lookup_type($3, tmp), " não são compatíveis para exponenciação!"));
                  exit(1);
            }

}
      | ID acesso_array {
            stackElement *tmp = peekS(scopeStack);
            acessoArrayID(&$$, &$1, &$2->code,lookup_variable_type(variablesTable,tmp, $1));
      }
      | endereco acesso_array {
            char *enderecoAcessoArray = cat($1->code,$2->code,"","","");
            freeRecord($1);
            freeRecord($2);
            $$ = createRecord(enderecoAcessoArray, "");
            free(enderecoAcessoArray);
      }
      | endereco {$$ = $1;}
      | base {$$ = $1;}
      ;

base : ID {baseID(&$$, &$1);}
      | NUMBER {baseIntNumber(&$$, &$1);}
      | NUMBERFLOAT {baseRealNumber(&$$, &$1);}
      | WORD {baseStringLiteral(&$$, &$1);}
      | TRUE {baseTrue(&$$);}
      | FALSE {baseFalse(&$$);}
      | chamada_funcao {$$ = $1;}
      | '(' expre_logica ')' {
            stackElement *tmp = peekS(scopeStack);
            char *s = cat("(", $2->code, ")", "", "");
            $$ = createRecord(s, lookup_type($2, tmp));
            freeRecord($2);
            free(s);
      }
      | acesso_ponteiro {$$ = $1;}
      ;

acesso_ponteiro : '*' ID {
            stackElement *tmp = peekS(scopeStack);

            char *s = cat("*", $2, "", "", "");
            char *tipoPonteiro = strdup(lookup_variable_type(variablesTable, tmp, $2));
            char *type = strtok(tipoPonteiro, "*");

            $$ = createRecord(s, type);
            free(s);
            free(type);
      }
      | '*' ID acesso_array {
            stackElement *tmp = peekS(scopeStack);

            char *s = cat("*(", $2, $3->code, ")", "");
            char *type = lookup_variable_type(variablesTable, tmp, $2);  

            $$ = createRecord(s, type);
            freeRecord($3);
            free(s);
      }

base_case_array: ID {}
                  | NUMBER {}
                  | NUMBERFLOAT {}
                  | WORD {}
                  | TRUE {}
                  | FALSE {}
                  ;

%%

int main (int argc, char ** argv) {
	int codigo;
      int mostrarTabelaDeSimbolos = 0;


      if (argc < 3) {
            printf("Usage: $./compiler input.txt output.txt\nClosing application...\n");
            exit(1);
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
      funcInfo = createSymbolTable(TABLE_SIZE);
      scopeStack = newStack();
      countFuncCallParams = 0;
      countFuncArgs = 0;
    
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
            printf("*******************************\n");
		printf("Mostrando tabela de funcoes com argumentos: \n");
		printf("*******************************\n");
		printTable(funcInfo);
	}

      return codigo;
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}


void insertFunctionParam(stackElement *tmp, char *paramName, char *paramType){
	int paramId = 0; 
	char strNum[30];
      char *paramKey;

	sprintf(strNum, "%d", paramId);
      paramKey = cat("p", strNum, "", "", "");

      while (lookup(functionsTable, tmp, paramKey)) {
            free(paramKey); 
            paramId++;
            sprintf(strNum, "%d", paramId);
            paramKey = cat("p", strNum, "", "", "");
      }
	char *newParamKey = cat(tmp->subp, "#p" , strNum, "", "");
      insert(functionsTable, newParamKey, paramName, paramType);
      free(paramKey);  
      free(newParamKey);
}

char* lookup_type(record *r, stackElement *tmp) {
	char* type = r->opt1;
	if (!strcmp(type, "id")) {
		SymbolInfos *info = lookup(variablesTable, tmp, r->code);
		if (info == NULL) {
                  yyerror(cat("Erro: Não pode usar variavel ", r->code, " antes da inicialização!", "", ""));
                  exit(1);
		} else {
                  printf("----- %s %s -----\n", r->code, info->type);
                  return info->type;
            }
	} else {
            printf("----- %s %s -----\n", r->code, r->opt1);
            return r->opt1;
      }
}


