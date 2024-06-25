#ifndef STACK
#define STACK

typedef struct stackElement
{
    char *subp;
    char *type;
    struct stackElement *next;
} stackElement;

typedef struct stack
{
    int top;
    stackElement *items;
} stack;

stackElement *createVarAttNode(stackElement *);
struct stack *newStack();
int size(struct stack *pt);
int isEmpty(struct stack *pt);
stackElement *pushS(struct stack *pt, char *, char *);
stackElement *peekS(struct stack *pt);
stackElement *peekBelowTop(struct stack *pt);
stackElement *popS(struct stack *pt);

#endif
