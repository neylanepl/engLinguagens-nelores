#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hashTable.h"

#define TABLE_SIZE 109

unsigned int hash(unsigned char *str, int tamanho)
{
    unsigned long hash = 5381;
    int c;

    while ((c = *str++))
        hash = ((hash << 5) + hash) + c;

    return hash % tamanho;
}

SymbolInfos *createSymbol(char *key, char *name, char *type)
{
    SymbolInfos *symbol = malloc(sizeof(SymbolInfos));

    symbol->key = strdup(key);
    symbol->name = strdup(name);
    symbol->type = strdup(type);

    return symbol;
}

FunctionInfos *createFunction(char *key, char *name, char *returnType, int numParams)
{
    FunctionInfos *function = (FunctionInfos *)malloc(sizeof(FunctionInfos));
    function->key = strdup(key);
    function->name = strdup(name);
    function->returnType = strdup(returnType);
    function->numParams = numParams;
    return function;
}

listNode *createListNode(SymbolInfos *symbol, FunctionInfos *function)
{
    listNode *node = (listNode *)malloc(sizeof(listNode));
    node->symbol = symbol;
    node->function = function;
    node->nextNode = NULL;
    return node;
}

SymbolTable *createSymbolTable(int size)
{
    SymbolTable *table = malloc(sizeof(SymbolTable));

    table->symbols = calloc(size, sizeof(listNode *));
    table->size = size;

    return table;
}

void insert(SymbolTable *table, char *key, char *name, char *type)
{
    unsigned int index = hash((unsigned char *)key, table->size);
    listNode *newNode = createListNode(createSymbol(key, name, type), NULL);
    newNode->nextNode = table->symbols[index];
    table->symbols[index] = newNode;
}

void insertFunction(SymbolTable *table, char *key, char *name, char *returnType, int numParams)
{
    unsigned int index = hash((unsigned char *)key, table->size);
    listNode *newNode = createListNode(NULL, createFunction(key, name, returnType, numParams));
    newNode->nextNode = table->symbols[index];
    table->symbols[index] = newNode;
}


SymbolInfos *lookup(SymbolTable *table, vatt *currentScope, char *name)
{
    while (currentScope->next != NULL) {
        char *key = cat(currentScope->subp, "#", name, "", "");
        unsigned int index = hash(key, table->size);

        listNode *current = table->symbols[index];

        while (current != NULL)
        {
            if (strcmp(current->symbol->key, key) == 0)
            {
                free(key);
                return current->symbol;
            }

            current = current->nextNode;
        }

        free(key);
        currentScope = currentScope->next;
    }

    return NULL;
}

FunctionInfos *lookupFunction(SymbolTable *table, char *key)
{
    unsigned int index = hash((unsigned char *)key, table->size);

    listNode *current = table->symbols[index];
    while (current != NULL)
    {
        if (current->function && strcmp(current->function->key, key) == 0)
        {
            return current->function;
        }
        current = current->nextNode;
    }

    return NULL;
}

void printTable(SymbolTable *table)
{
    for (int i = 0; i < table->size; i++)
    {
        listNode *current = table->symbols[i];
        while (current != NULL)
        {
            if (current->symbol)
            {
                printf("--------------------------\n");
                printf("Chave:  | %s\n", current->symbol->key);
                printf("Nome:   | %s\n", current->symbol->name);
                printf("Tipo:   | %s\n", current->symbol->type);
            }
            if (current->function)
            {   
                                printf("--------------------------\n");
                printf("Chave:  | %s\n", current->function->key);
                printf("Nome:   | %s\n", current->function->name);
                printf("Tipo de retorno:   | %s\n", current->function->returnType);
                printf("Número de Parâmetros:   | %d\n", current->function->numParams);
                }
            current = current->nextNode;
        }
    }
}

void freeSymbolTable(SymbolTable *table)
{
    for (int i = 0; i < table->size; i++)
    {
        listNode *current = table->symbols[i];
        while (current != NULL)
        {
            listNode *temp = current;
            current = current->nextNode;
            if (temp->symbol)
            {
                free(temp->symbol->key);
                free(temp->symbol->name);
                free(temp->symbol->type);
                free(temp->symbol);
            }
            if (temp->function)
            {
                free(temp->function->key);
                free(temp->function->name);
                free(temp->function->returnType);
                free(temp->function);
            }
            free(temp);
        }
    }
    free(table->symbols);
    free(table);
}

char *lookup_variable_type(SymbolTable *table, vatt *currentScope, char *name)
{
    while (currentScope->next != NULL) {
        char *key = cat(currentScope->subp, "#", name, "", "");
        unsigned int index = hash(key, table->size);

        listNode *current = table->symbols[index];

        while (current != NULL)
        {
            if (strcmp(current->symbol->key, key) == 0)
            {
                free(key);
                return current->symbol->type;
            }

            current = current->nextNode;
        }

        free(key);
        currentScope = currentScope->next;
    }

    return NULL;
}
