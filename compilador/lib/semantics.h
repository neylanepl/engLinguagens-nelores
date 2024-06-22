#ifndef SEMANTICS
#define SEMANTICS

#include "record.h"

static int ifID = 0;
static int whileID = 0;
static int condicionalID = 0;

char *getIfID();
char *incIfID();
char *getWhileID();
char *incWhileID();
char *getCondicionalID();
char *incCondicionalID();

void declaracaoVariavelTipada(record **, record **, char **);
char *cat(char *, char *, char *, char *, char *);
void atribuicaoVariavelTipada(record **, record **, char **, record **);
void baseTrue(record **);
void baseFalse(record **);
void baseStringLiteral(record **, char **);
void baseID(record **, char **);
void baseIntNumber(record **, int *);
void baseRealNumber(record **, float *);
void chamadaParamFuncao(record **ss, char **s1, record **s3, char *type);
void declaracaoFuncao(record **ss, char **s2, record **s4, char **s7, record **s9);
void declaracaoProcedimento(record **ss, char **s2, record **s4, record **s7);
void argumentoTipoId(record **ss, char **s1, record **s3);
void argumentoTipoIdRecusao(record **ss, char **s1, record **s3, record **s5);
void scanfPalavraIdeEndereco(record **ss, char **s3, char **s5);
void ifBlock(record **ss, record **exp, record **commands, char *id);
void ifElseBlock(record **ss, record **exp, record **ifCommands, record **elseCommands, char *id);
void iteradorWhile(record **ss, record **exp, record **commands, char *id);
void expressaoAritmetica(record **ss, record **s1, char *s2, record **s3, char *type);
void atribuicaoVariavel(record **ss, record **s1, record **s2);
void atribuicaoVariavelMaisIgual(record **ss, record **s1, record **s2);
void atribuicaoVariavelMenosIgual(record **ss, record **s1, record **s2);
void atribuicaoIncreDecre(record **ss, char **s1, char **s2);
void arraySemAtribuicao(record **ss, record **s2, record **s3, char *type);
void scanfPalavraEnderecoAcessoArray(record **ss, char **s3, char **s4, char **s5);
void scanfPalavraAcessoArray(record **ss, char **s3, char **s5, char **s6);
void atribuicaoArrayVariavel(record **ss, record **s1, record **s2, record **s4);
void atribuicaoArrayMoreEqualVariavel(record **ss, record **s1, record **s2, record **s4);
void atribuicaoArrayMinusEqualVariavel(record **ss, record **s1, record **s2, record **s4);
void acessoArrayID(record **ss, char **s1, char **s2, char *type);

#endif