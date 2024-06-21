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
printf("Digite o número de linhas da segunda matriz: ");
printf("\n");
scanf("%d",&linhas2);
printf("Digite o número de colunas da segunda matriz: ");
printf("\n");
scanf("%d",&colunas2);
printf("Digite os elementos da segunda matriz:\n");
printf("\n");
i=0;
WHILE_2:
if (!(i<linhas2)) goto endWHILE_2;
j=0;
WHILE_3:
if (!(j<colunas2)) goto endWHILE_3;
printf("Elemento [%d][%d]: ");
printf("%d", i);
printf("%d", j);
printf("\n");
scanf("%d",&matriz2[i][j]);
j++;
goto WHILE_3;
endWHILE_3:
i++;
goto WHILE_2;
endWHILE_2:
if (!(linhas1==linhas2&&colunas1==colunas2)) goto elseIF_0;
i=0;
WHILE_4:
if (!(i<linhas1)) goto endWHILE_4;
j=0;
WHILE_5:
if (!(j<colunas1)) goto endWHILE_5;
soma[i][j]=matriz1[i][j]+matriz2[i][j];
j++;
goto WHILE_5;
endWHILE_5:
i++;
goto WHILE_4;
endWHILE_4:
printf("Soma das matrizes:\n");
printf("\n");
i=0;
WHILE_6:
if (!(i<linhas1)) goto endWHILE_6;
j=0;
WHILE_7:
if (!(j<colunas1)) goto endWHILE_7;
printf("%d ");
printf("%d", soma[i][j]);
printf("\n");
j++;
goto WHILE_7;
endWHILE_7:
printf("\n");
printf("\n");
i++;
goto WHILE_6;
endWHILE_6:
goto endifIF_0;
elseIF_0:
printf("A soma das matrizes não é possível (dimensões incompatíveis).\n");
printf("\n");
endifIF_0:
if (!(colunas1==linhas2)) goto elseIF_1;
i=0;
WHILE_8:
if (!(i<linhas1)) goto endWHILE_8;
j=0;
WHILE_9:
if (!(j<colunas2)) goto endWHILE_9;
produto[i][j]=0;
int k = 0;
WHILE_10:
if (!(k<colunas1)) goto endWHILE_10;
produto[i][j]+=matriz1[i][k]*matriz2[k][j];
k++;
goto WHILE_10;
endWHILE_10:
j++;
goto WHILE_9;
endWHILE_9:
i++;
goto WHILE_8;
endWHILE_8:
printf("Produto das matrizes:\n");
printf("\n");
i=0;
WHILE_11:
if (!(i<linhas1)) goto endWHILE_11;
j=0;
WHILE_12:
if (!(j<colunas2)) goto endWHILE_12;
printf("%d ");
printf("%d", produto[i][j]);
printf("\n");
j++;
goto WHILE_12;
endWHILE_12:
printf("\n");
printf("\n");
i++;
goto WHILE_11;
endWHILE_11:
goto endifIF_1;
elseIF_1:
printf("O produto das matrizes não é possível (dimensões incompatíveis).\n");
printf("\n");
endifIF_1:
}