#ifndef HASHTABLE
#define HASHTABLE

#define TABLE_SIZE 109

typedef struct SymbolInfos
{
    char *key;
    char *name;
    char *type;
} SymbolInfos;

typedef struct listNode
{
    SymbolInfos *symbol;
    struct listNode *nextNode;
} listNode;

typedef struct
{
    listNode **symbols;
    int size;
} SymbolTable;

unsigned int hash(unsigned char *str, int tamanho);
SymbolInfos *createSymbol(char *key, char *name, char *type);
listNode *createListNode(SymbolInfos *symbol);
SymbolTable *createSymbolTable(int size);
void insert(SymbolTable *table, char *key, char *name, char *type);
SymbolInfos *lookup(SymbolTable *table, char *key);
void printTable(SymbolTable *table);
void freeSymbolTable(SymbolTable *table);
char *lookup_variable_type(SymbolTable *table, char *key);

#endif
