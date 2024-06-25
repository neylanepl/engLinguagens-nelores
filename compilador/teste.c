#include <stdio.h>
#include <math.h>

<<<<<<< HEAD
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
=======

int main(){
int linhas1;
int linhas2;
int colunas1;
int colunas2;
float matriz1[100][100];
float matriz2[100][100];
float soma[100][100];
float produto[100][100];
printf("Digite o número de linhas da primeira matriz: ");
printf("\n");
scanf("%d", &linhas1);
printf("Digite o número de colunas da primeira matriz: ");
printf("\n");
scanf("%d", &colunas1);
printf("Digite os elementos da primeira matriz:\n");
printf("\n");
int i = 0;
int j = 0;
{
WHILE_0:
if (!(i<linhas1)) goto endWHILE_0;
j=0;
{
WHILE_1:
if (!(j<colunas1)) goto endWHILE_1;
printf("Insira o elemento ");
printf("%d", i);
printf("%d", j);
printf(":");
printf("\n");
scanf("%f", &matriz1[i][j]);
j++;
goto WHILE_1;
endWHILE_1:
}
i++;
goto WHILE_0;
endWHILE_0:
}
printf("A matriz 1 lida é:");
printf("\n");
i=0;
{
WHILE_2:
if (!(i<linhas1)) goto endWHILE_2;
j=0;
{
WHILE_3:
if (!(j<colunas1)) goto endWHILE_3;
printf("%f", matriz1[i][j]);
printf(" ");
j++;
goto WHILE_3;
endWHILE_3:
}
printf(" ");
printf("\n");
i++;
goto WHILE_2;
endWHILE_2:
}
printf("Digite o número de linhas da segunda matriz: ");
printf("\n");
scanf("%d", &linhas2);
printf("Digite o número de colunas da segunda matriz: ");
printf("\n");
scanf("%d", &colunas2);
printf("Digite os elementos da segunda matriz:\n");
printf("\n");
i=0;
{
WHILE_4:
if (!(i<linhas2)) goto endWHILE_4;
j=0;
{
WHILE_5:
if (!(j<colunas2)) goto endWHILE_5;
printf("Elemento: ");
printf("%d", i);
printf("%d", j);
printf(":");
printf("\n");
scanf("%f", &matriz2[i][j]);
j++;
goto WHILE_5;
endWHILE_5:
}
i++;
goto WHILE_4;
endWHILE_4:
}
printf("A matriz 2 lida é:");
printf("\n");
i=0;
{
WHILE_6:
if (!(i<linhas2)) goto endWHILE_6;
j=0;
{
WHILE_7:
if (!(j<colunas2)) goto endWHILE_7;
printf("%f", matriz2[i][j]);
printf(" ");
j++;
goto WHILE_7;
endWHILE_7:
}
printf(" ");
printf("\n");
i++;
goto WHILE_6;
endWHILE_6:
}
{
if (!(linhas1==linhas2&&colunas1==colunas2))goto elseIFZAO_0_0;
i=0;
{
WHILE_8:
if (!(i<linhas1)) goto endWHILE_8;
j=0;
{
WHILE_9:
if (!(j<colunas1)) goto endWHILE_9;
soma[i][j]=matriz1[i][j]+matriz2[i][j];
j++;
goto WHILE_9;
endWHILE_9:
}
i++;
goto WHILE_8;
endWHILE_8:
}
printf("Soma das matrizes:\n");
printf("\n");
i=0;
{
WHILE_10:
if (!(i<linhas1)) goto endWHILE_10;
j=0;
{
WHILE_11:
if (!(j<colunas1)) goto endWHILE_11;
printf("%f", soma[i][j]);
printf(" ");
j++;
goto WHILE_11;
endWHILE_11:
}
printf(" ");
printf("\n");
i++;
goto WHILE_10;
endWHILE_10:
}
goto endifIFZAO_0;
}
elseIFZAO_0_0:
printf("A soma das matrizes não é possível (dimensões incompatíveis).");
printf("\n");

endifIFZAO_0:

{
if (!(colunas1==linhas2)) goto endifIFZAO_1;
i=0;
{
WHILE_12:
if (!(i<linhas1)) goto endWHILE_12;
j=0;
{
WHILE_13:
if (!(j<colunas2)) goto endWHILE_13;
produto[i][j]=0.000000;
int k = 0;
{
WHILE_14:
if (!(k<colunas1)) goto endWHILE_14;
produto[i][j]+=matriz1[i][k]*matriz2[k][j];
k++;
goto WHILE_14;
endWHILE_14:
}
j++;
goto WHILE_13;
endWHILE_13:
}
i++;
goto WHILE_12;
endWHILE_12:
}
printf("Produto das matrizes:\n");
printf("\n");
i=0;
{
WHILE_15:
if (!(i<linhas1)) goto endWHILE_15;
j=0;
{
WHILE_16:
if (!(j<colunas2)) goto endWHILE_16;
printf("%f", produto[i][j]);
printf(" ");
j++;
goto WHILE_16;
endWHILE_16:
}
printf(" ");
printf("\n");
i++;
goto WHILE_15;
endWHILE_15:
}
}
endifIFZAO_1:

>>>>>>> develop
}