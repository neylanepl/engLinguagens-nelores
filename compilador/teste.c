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
printf("Digite um número: ");
scanf("%d",&num);
if (!(num>=0&&num<=25)) goto else3;
count025=count025+1;
goto endif3;
else3:
if (!(num>=26&&num<=50)) goto else2;
count2650=count2650+1;
goto endif2;
else2:
if (!(num>=51&&num<=75)) goto else1;
count5175=count5175+1;
goto endif1;
else1:
if (!(num>=76&&num<=100)) goto endif0;
count76100=count76100+1;
endif0:
endif1:
endif2:
endif3:
goto WHILE_0;
endWHILE_0:
printf("Quantidade de números nos intervalos:");
printf("\n");
printf("[0, 25]: ");
printf("%d", count025);
printf("\n");
printf("[26, 50]: ");
printf("%d", count2650);
printf("\n");
printf("[51, 75]: ");
printf("%d", count5175);
printf("\n");
printf("[76, 100]: ");
printf("%d", count76100);
printf("\n");
}
int main(){
analiseDeIntervalos();
}