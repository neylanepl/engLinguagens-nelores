#include <stdio.h>
#include <math.h>


int main(){
int a = 10;
printf("Valor de x no escopo principal: ");
printf("%d", a);
printf("\n");
{
if (!(a==10)) goto endifIFZAO_0;
int x = 20;
printf("Valor de x no escopo aninhado: ");
printf("%d", x);
printf("\n");
{
if (!(x==20)) goto endifIFZAO_1;
int b = 30;
printf("Valor de x no escopo mais interno: \n");
printf("%d", x);
printf("\n");

} endifIFZAO_1:

{
if (!(x==20)) goto endifIFZAO_2;
int b = 30;
printf("Valor de x no escopo mais interno: \n");
printf("%d", x);
printf("\n");

} endifIFZAO_2:

printf("Valor de x após o escopo mais interno: ");
printf("%d", x);
printf("\n");

} endifIFZAO_0:

printf("Valor de x após o escopo aninhado: ");
printf("%d", a);
printf("\n");
}