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
scanf("%d", &num);
if (!(num>=0&&num<=25))goto elseIFZAO_0_2;
count025=count025+1;
goto endifIFZAO_0;
elseIFZAO_0_2:
if (!(num>=26&&num<=50))goto elseIFZAO_0_1;
count2650=count2650+1;
goto endifIFZAO_0;
elseIFZAO_0_1:
if (!(num>=51&&num<=75))goto elseIFZAO_0_0;
count5175=count5175+1;
goto endifIFZAO_0;
elseIFZAO_0_0:
if (!(num>=76&&num<=100)) goto endifIFZAO_0;
count76100=count76100+1;
endifIFZAO_0:
endifIFZAO_0:

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