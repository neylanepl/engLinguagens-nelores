#include "stack.h"
#include <stdlib.h>
#include <stdio.h>

vatt *createVarAttNode(vatt *x) {
    vatt *no = malloc(sizeof(vatt));
    no->subp = x->subp;
    no->type = x->type;
    no->next = NULL;
    return no;
}

struct stack* newStack()
{
    struct stack *pt = (struct stack*)malloc(sizeof(struct stack));
 
    pt->top = -1;
    pt->items = (void *) malloc(sizeof(vatt));
    pt->items->next = NULL;
 
    return pt;
}
 
int size(struct stack *pt) {
    return pt->top + 1;
}
 
int isEmpty(struct stack *pt) {
    return pt->top == -1;
}

vatt *pushS(struct stack *pt, char *subp, char *type) {
 
    printf("Adicionando no escopo:  %s %s \n", subp, type);
 
    // adiciona um elemento e incrementa o índice do topo
    vatt *new_node;
    new_node = (vatt *) malloc(sizeof(vatt));

    new_node->subp = subp;
    new_node->type = type;
    new_node->next = pt->items;
    pt->items = new_node;
    pt->top++;
    return new_node;
}
 
vatt *peekS(struct stack *pt)
{
    if (!isEmpty(pt)) {
        return pt->items;
    }
    else {
        return NULL;
    }
}

vatt *peekBelowTop(struct stack *pt) {
    if (pt->top < 1) { // Verifica se há pelo menos dois elementos na pilha
        return NULL;
    }
    return pt->items->next; // Retorna o elemento logo abaixo do topo
}

vatt *popS(struct stack *pt){
    if (isEmpty(pt)){
        return NULL;
    }
    vatt *tmp = peekS(pt);

    printf("Removendo do escopo:  %s\n", tmp->subp);

    vatt *next_node = NULL;

    if (pt->items == NULL) {
        return NULL;
    }

    next_node = pt->items->next;
    free(pt->items);
    pt->items = next_node;
    pt->top--;

    return tmp;
}