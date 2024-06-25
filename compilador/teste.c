#include <stdio.h>
#include <math.h>

int mdc(int n, int m, int* r){
{
if (!(m%n==0))goto elseIFZAO_0_2;
*r=n;
goto endifIFZAO_0;
}
elseIFZAO_0_2:
{
if (!(n%m==0))goto elseIFZAO_0_1;
*r=m;
goto endifIFZAO_0;
}
elseIFZAO_0_1:
{
if (!(m>n))goto elseIFZAO_0_0;
mdc(r, m%n, n);
goto endifIFZAO_0;
}
elseIFZAO_0_0:
mdc(r, n%m, m);



endifIFZAO_0:

return 0;
}
int main(){
int n;
int m;
int resultado;
printf("Digite o valor de n: ");
printf("\n");
scanf("%d", &n);
printf("Digite o valor de m: ");
printf("\n");
scanf("%d", &m);
mdc(&resultado, m, n);
printf("O mdc de ");
printf("%d", n);
printf(" e ");
printf("%d", m);
printf(" é: ");
printf("%d", resultado);
printf("\n");
}