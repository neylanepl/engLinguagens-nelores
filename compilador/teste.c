#include <stdio.h>
#include <math.h>

int analiseDeIntervalos(){
int num;
int count025 = 0;
int count2650 = 0;
int count5175 = 0;
int count76100 = 0;
while(1){
printf("Digite um número: ");
scanf("%d",&num);
if(num<0){
break;

}
if(num>=0&&num<=25){
count025=count025+1;

}
else if(num>=26&&num<=50){
count2650=count2650+1;

}
else if(num>=51&&num<=75){
count5175=count5175+1;

}
else if(num>=76&&num<=100){
count76100=count76100+1;

}
printf("Quantidade de números nos intervalos:\n");
printf("[0, 25]:",count025);
printf("[26, 50]:",count2650);
printf("[51, 75]:",count5175);
printf("[76, 100]:",count76100);

}
}
int main(){
analiseDeIntervalos();
}