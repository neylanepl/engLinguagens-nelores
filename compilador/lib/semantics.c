#include "semantics.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "record.h"

void dec1(record **ss, record **s2, char **s4)
{
	char *str;

	if (0 == strcmp(*s4, "string"))
	{
		str = cat("char *", " ", (*s2)->code, ";\n", "");
	}
	else if (0 == strcmp(*s4, "bool"))
	{
		str = cat("int", " ", (*s2)->code, ";\n", "");
	}
	else
	{
		str = cat(*s4, " ", (*s2)->code, ";\n", "");
	}
	*ss = createRecord(str, *s4);
	free(*s4);
	freeRecord(*s2);
	free(str);
}


void init1(record **ss, record **id, char **type, record **expr)
{
	char *str;

	if (0 == strcmp(*type, "string"))
	{
		str = cat("char * ", (*id)->code, " = ", (*expr)->code, ";\n");
	}
	else if (0 == strcmp(*type, "bool"))
	{
		str = cat("int ", (*id)->code, " = ", (*expr)->code, ";\n");
	}
	else
	{
		str = cat(*type, " ", (*id)->code, " = ", (*expr)->code);
		str = cat(str, ";\n", "", "", "");
	}

	*ss = createRecord(str, *type);

	freeRecord(*id);
	freeRecord(*expr);
	free(*type);
	free(str);
}

// VALUE TRUE
void baseTrue(record **ss)
{
	*ss = createRecord("1", "bool");
}

// VALUE FALSE
void baseFalse(record **ss)
{
	*ss = createRecord("0", "bool");
}

void printStringLiteral(record **ss, char **s3)
{
	char *str = cat("printf(", *s3, ")", ";\n", "");
	*ss = createRecord(str, "");
	free(*s3);
	free(str);
};

void printLnStringLiteral(record **ss, char **s3, record**s5)
{
    char *str = cat("printf(", *s3, ",", (*s5)->code, ");\n");
    *ss = createRecord(str, "");
    free(*s3);
    freeRecord(*s5);
    free(str);
};

// STRING LITERAL
void baseStringLiteral(record **ss, char **s1)
{
	*ss = createRecord(*s1, "string");
	free(*s1);
}

void baseID(record **ss, char **s1) {
    *ss = createRecord(*s1, "id");
	free(*s1);
}

// INT NUMBER
void baseIntNumber(record **ss, int *s1)
{
	char strNum[50];
	sprintf(strNum, "%d", *s1);

	*ss = createRecord(strNum, "int");
}
// NUMBER REAL
void baseRealNumber(record **ss, float *s1)
{
	char strNum[50];
	sprintf(strNum, "%f", *s1);
	*ss = createRecord(strNum, "float");
}

// chamada de função : ID '(' params ')'
void chamadaParamFuncao(record **ss, char **s1, record **s3, char *type)
{
	char *str = cat(*s1, "(", (*s3)->code, ")", "");
	*ss = createRecord(str, type);
	freeRecord(*s3);
	// free(*s1);
	free(str);
}

// Declaração de função : TIPE ID '(' params_def ')' '{' '}'
void declaracaoFuncao(record **ss, char **s2, record **s4, char **s7, record **s9)
{
	char *str1;

	if (0 == strcmp(*s7, "string"))
	{
		str1 = cat("char *", " ", *s2, "(", (*s4)->code);
	}
	else if (0 == strcmp(*s7, "bool"))
	{
		str1 = cat("int", " ", *s2, "(", (*s4)->code);
	}
	else
	{
		str1 = cat(*s7, " ", *s2, "(", (*s4)->code);
	}
	char *str2 = cat(str1, "){\n", (*s9)->code, "}", "");
	*ss = createRecord(str2, "");
	freeRecord(*s4);
	freeRecord(*s9);
	// free(*s2);
	free(*s7);
	free(str1);
	free(str2);
};

// Declaração de procedimento : PROCEDURE ID '(' args_com_vazio ')' '{' bloco '}'
void declaracaoProcedimento(record **ss, char **s2, record **s4, record **s7) {
	char *str1 = cat("void ", *s2, "(", (*s4)->code, "");
	char *str2 = cat(str1, "){\n", (*s7)->code, "}\n", "");
	*ss = createRecord(str2, "void");
	freeRecord(*s4);
	freeRecord(*s7);
	//free(*s2);
	free(str1);
	free(str2);
};

//args : tipo ID 
void argumentoTipoId(record **ss, char **s1, record **s3) {
	char *str;

	if(0 == strcmp((*s3)->code, "string")){
		str = cat("char *", " ", (*s1), "", "");
	} else if (0 == strcmp((*s3)->code, "boolean")){
		str = cat("int", " ", (*s1), "", "");
	} else {
		str = cat((*s3)->code, " ", (*s1), "", "");
	}
	*ss = createRecord(str, "");
	freeRecord(*s3);
	free(*s1);
	free(str);
};


// | expre_arit X termo
void ex2(record **ss, record **s1, char *s2, record **s3, char *type) {
    char *str;
    if (strcmp(s2, "^") == 0) {
        if (strcmp(type, "int") == 0) {
            str = cat("(int)pow((double)(", (*s1)->code, "), (double)(", (*s3)->code, "))");
        } else {
            str = cat("pow(", (*s1)->code, ", ", (*s3)->code, ")");
        }
    } else {
        str = cat((*s1)->code, s2, (*s3)->code, "", "");
    }

    printf("---- %s %s %s ----\n", (*s1)->code, s2, (*s3)->code);
    freeRecord(*s1);
    freeRecord(*s3);
    *ss = createRecord(str, type);
    free(str);
}