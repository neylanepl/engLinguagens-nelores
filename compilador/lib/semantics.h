#ifndef SEMANTICS
#define SEMANTICS

#include "record.h"

void dec1(record **, record **, char **);
char *cat(char *, char *, char *, char *, char *);
void init1(record **, record **, char **, record **);
void baseTrue(record **);
void baseFalse(record **);
void printStringLiteral(record **, char **);
void printLnStringLiteral(record **ss, char **s, record **s1);
void baseStringLiteral(record **, char **);
void baseID(record **, char **);
void baseIntNumber(record **, int *);
void baseRealNumber(record **, float *);
void chamadaParamFuncao(record **ss, char **s1, record **s3, char *type);
void declaracaoFuncao(record **ss, char **s2, record **s4, char **s7, record **s9);
void declaracaoProcedimento(record **ss, char **s2, record **s4, record **s7);
void argumentoTipoId(record **ss, char **s1, record **s3);
void scanfPalavraIdeEndereco(record **ss, char **s3, char **s5);
void ex2(record **ss, record **s1, char *s2, record **s3, char *type);
void atribuicaoVariavel(record **ss, record **s1, record **s2);
void atribuicaoVariavelMaisIgual(record **ss, record **s1, record **s2);
void atribuicaoVariavelMenosIgual(record **ss, record **s1, record **s2);
void atribuicaoIncreDecre(record **ss, char **s1, char **s2);

#endif