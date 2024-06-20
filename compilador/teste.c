#include <stdio.h>
#include <math.h>


int main(){
int linhas1;
int linhas2;
int colunas1;
int colunas2;
int matriz1[100][100];
int matriz2[100][100];
int soma[100][100];
int produto[100][100];
printf("Digite o número de linhas da primeira matriz: ");
printf("\n");
scanf("%d",&linhas1);
printf("Digite o número de colunas da primeira matriz: ");
printf("\n");
scanf("%d",&colunas1);
printf("Digite os elementos da primeira matriz:\n");
printf("\n");
int i = 0;
int j = 0;
WHILE_0:
if (!(i<linhas1)) goto endWHILE_0;
j=0;
WHILE_1:
if (!(j<colunas1)) goto endWHILE_1;
printf("Insira o elemento");
printf("%d", i);
printf("%d", j);
printf(":");
printf("\n");
scanf("%d",&matriz1[i][j]);
j++;
goto WHILE_1;
endWHILE_1:
i++;
goto WHILE_0;
endWHILE_0:
printf("A matriz 1 lida é:");
printf("\n");
i=0;
WHILE_2:
if (!(i<linhas1)) goto endWHILE_2;
j=0;
WHILE_3:
if (!(j<colunas1)) goto endWHILE_3;
printf("%d", matriz1[i][j]);
printf("\n");
j++;
goto WHILE_3;
endWHILE_3:
printf("\n");
printf("\n");
i++;
goto WHILE_2;
endWHILE_2:
}