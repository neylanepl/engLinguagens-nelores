#include <stdio.h>
#include <math.h>

void mdc(int n, int m, int* r){
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
mdc(n, m%n, r);
goto endifIFZAO_0;
}
elseIFZAO_0_0:
mdc(m, n%m, r);



endifIFZAO_0:

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
mdc(n, m, &resultado);
printf("O mdc de ");
printf("%d", n);
printf(" e ");
printf("%d", m);
printf(" é: ");
printf("%d", resultado);
printf("\n");
}