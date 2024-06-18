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

listNode *createListNode(SymbolInfos *symbol)
{
    listNode *node = malloc(sizeof(listNode));
    node->symbol = symbol;
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

    SymbolInfos *symbol = createSymbol(key, name, type);
    listNode *node = createListNode(symbol);

    if (table->symbols[index] == NULL)
    {
        table->symbols[index] = node;
    }
    else
    {
        listNode *current = table->symbols[index];

        while (current->nextNode != NULL)
        {
            current = current->nextNode;
        }

        current->nextNode = node;
    }
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

void printTable(SymbolTable *table)
{
    for (int i = 0; i < table->size; i++)
    {
        listNode *current = table->symbols[i];

        while (current != NULL)
        {
            printf("--------------------------\n");
            printf("Chave:  | %s\n", current->symbol->key);
            printf("Nome:   | %s\n", current->symbol->name);
            printf("Tipo:   | %s\n", current->symbol->type);

            current = current->nextNode;
        }
    }
    printf("--------------------------\n");
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
            free(temp->symbol->key);
            free(temp->symbol->name);
            free(temp->symbol->type);
            free(temp->symbol);
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
