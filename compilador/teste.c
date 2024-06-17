#include <stdio.h>
#include <math.h>

int analiseDeIntervalos(){
int num;
int count025 = 0;
int count2650 = 0;
int count5175 = 0;
int count76100 = 0;
if (!(1)) { goto else0; }
int a = 1;
goto endif0;
else0:
int b = 2;
endif:
while0:
if(num>0){
printf("Digite um número: ");
scanf("%d",&num);
if (!(num>=0&&num<=25)) { goto else1; }
count025=count025+1;
goto endif1;
else1:
if (!(num>=26&&num<=50)) { goto else2; }
count2650=count2650+1;
goto endif2;
else2:
if (!(num>=51&&num<=75)) { goto else3; }
count5175=count5175+1;
goto endif3;
else3:
if (!(num>=76&&num<=100)) { goto else4; }
count76100=count76100+1;
goto endif4;
else4:
goto while0;
}
fimWhile0:
printf("Quantidade de números nos intervalos:\n");
printf("[0, 25]:",count025);
printf("[26, 50]:",count2650);
printf("[51, 75]:",count5175);
printf("[76, 100]:",count76100);
}
int main(){
analiseDeIntervalos();
}