#ifndef HASHTABLE
#define HASHTABLE

#include "stack.h"
#include "semantics.h"

#define TABLE_SIZE 109

typedef struct FunctionInfos
{
    char *key;
    char *name;
    char *returnType;
    int numParams;
} FunctionInfos;

typedef struct SymbolInfos
{
    char *key;
    char *name;
    char *type;
} SymbolInfos;

typedef struct listNode
{
    SymbolInfos *symbol;
    FunctionInfos *function;
    struct listNode *nextNode;
} listNode;

typedef struct
{
    listNode **symbols;
    int size;
} SymbolTable;

unsigned int hash(unsigned char *str, int tamanho);
SymbolInfos *createSymbol(char *key, char *name, char *type);
FunctionInfos *createFunction(char *key, char *name, char *returnType, int numParams);
listNode *createListNode(SymbolInfos *symbol, FunctionInfos *function);
SymbolTable *createSymbolTable(int size);
void insert(SymbolTable *table, char *key, char *name, char *type);
void insertFunction(SymbolTable *table, char *key, char *name, char *returnType, int numParams);
SymbolInfos *lookup(SymbolTable *table, stackElement *currentScope, char *key);
FunctionInfos *lookupFunction(SymbolTable *table, char *key);
void printTable(SymbolTable *table);
void freeSymbolTable(SymbolTable *table);
char *lookup_variable_type(SymbolTable *table, stackElement *currentScope, char *key);

#endif
