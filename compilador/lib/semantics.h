#ifndef SEMANTICS
#define SEMANTICS

#include "record.h"

void dec1(record **, record **, char **);
char * cat(char *, char *, char *, char *, char *);
void init1(record **, record **, char **, record **);
void baseTrue(record **);
void baseFalse(record **);
void baseStringLiteral(record **, char **);
void baseIntNumber(record **, int *);
void baseRealNumber(record **, float *);

#endif