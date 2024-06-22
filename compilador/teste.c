#include <stdio.h>
#include <math.h>

int analiseDeIntervalos(){
int num = 1;
int count025 = 0;
int count2650 = 0;
int count5175 = 0;
int count76100 = 0;
WHILE_0:
if (!(num>0)) goto endWHILE_0;
printf("Digite um número, caso deseje sair do loop insira um negativo: ");
scanf("%d",&num);
if (!(num>=0&&num<=25)) goto elseIF_0;
count025=count025+1;
goto endifIF_0;
elseIF_0:
if (!(num>=26&&num<=50)) goto elseIF_1;
count2650=count2650+1;
goto endifIF_1;
elseIF_1:
if (!(num>=51&&num<=75)) goto elseIF_2;
count5175=count5175+1;
goto endifIF_2;
elseIF_2:
if (!(num>=76&&num<=100)) goto endifIF_3;
count76100=count76100+1;
endifIF_3:
endifIF_2:
endifIF_1:
endifIF_0:
goto WHILE_0;
endWHILE_0:
printf("Quantidade de números nos intervalos:\n");
printf("[0, 25]:");
printf("%d", count025);
printf("\n");
printf("[26, 50]:");
printf("%d", count2650);
printf("\n");
printf("[51, 75]:");
printf("%d", count5175);
printf("\n");
printf("[76, 100]:");
printf("%d", count76100);
printf("\n");
}
int main(){
analiseDeIntervalos();
}