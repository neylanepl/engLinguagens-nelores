#include <stdio.h>
#include <math.h>

int mdc(int n, int m, int* r){
if (!(m%n==0)) goto elseIF_0;
*r=n;
goto endifIF_0;
elseIF_0:
if (!(n%m==0)) goto elseIF_1;
*r=m;
goto endifIF_1;
elseIF_1:
if (!(m>n)) goto elseIF_2;
mdc(n, m%n, r);
goto endifIF_2;
elseIF_2:
mdc(m, n%m, r);
endifIF_2:
endifIF_1:
endifIF_0:
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
mdc(n, m, &resultado);
printf("O mdc de ");
printf("%d", n);
printf(" e ");
printf("%d", m);
printf(" é: ");
printf("%d", resultado);
printf("\n");
}