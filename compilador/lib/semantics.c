#include "semantics.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "record.h"

char * getIfID(){
    char *outStr = (char *) malloc(sizeof(char) * 30);
	sprintf(outStr, "%d", ifID);

    return outStr;
};
char * incIfID(){
    char *outStr = (char *) malloc(sizeof(char) * 30);
    ifID++;
	sprintf(outStr, "%d", ifID);

    return outStr;
};


char * getWhileID(){
    char *outStr = (char *) malloc(sizeof(char) * 30);
	sprintf(outStr, "%d", whileID);

    return outStr;
};
char * incWhileID(){
    char *outStr = (char *) malloc(sizeof(char) * 30);
    whileID++;
	sprintf(outStr, "%d", whileID);

    return outStr;
};


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

void printLnStringLiteral(record **ss, char **s3, record **s5)
{
	char *str = cat("printf(", *s3, ",", (*s5)->code, ");\nprintf(\"\\n\");");
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

void baseID(record **ss, char **s1)
{
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
void declaracaoProcedimento(record **ss, char **s2, record **s4, record **s7)
{
	char *str1 = cat("void ", *s2, "(", (*s4)->code, "");
	char *str2 = cat(str1, "){\n", (*s7)->code, "}\n", "");
	*ss = createRecord(str2, "void");
	freeRecord(*s4);
	freeRecord(*s7);
	// free(*s2);
	free(str1);
	free(str2);
};



//if_simples : IF '(' expre_logica_iterador ')' '{' bloco '}'
void ctrl_b1(record **ss, record **exp, record **commands) {
	char *id = getIfID();
	char *str1 = cat("if (!(", (*exp)->code, ")) goto endif", id,";\n");
	char *str2 = cat(str1, (*commands)->code,"endif", id, ":\n");
	*ss = createRecord(str2, "");
	freeRecord(*exp);
	freeRecord(*commands);
	free(str1);
	free(str2);
	incIfID();
}

//if_else : IF '(' expre_logica_iterador ')' '{' bloco '}' ELSE else_aux
void ctrl_b2(record **ss, record **exp, record **ifCommands, record **elseCommands) {
	char *id = getIfID();
	char *str1 = cat("if (!(", (*exp)->code, ")) goto else", id,";\n");
	char *str2 = cat(str1, (*ifCommands)->code, "goto endif", id, cat(";\nelse", id, ":\n", "", ""));
	char *str3 = cat(str2, (*elseCommands)->code, "endif", id, ":\n");
	*ss = createRecord(str3, id);
	freeRecord(*exp);
	freeRecord(*ifCommands);
	freeRecord(*elseCommands);
	free(str1);
	free(str2);
	free(str3);
	incIfID();
}

//iteracao : WHILE '(' expre_logica_iterador ')' '{' bloco '}'
void ctrl_b3(record **ss, record **exp, record **commands) {
	char *id = getWhileID();
	char *str1 = cat("while", id, ":\nif (!(", (*exp)->code, cat(")) goto endwhile", id, ";\n", "", ""));
	char *str2 = cat(str1, (*commands)->code, "goto while", id, cat(";\nendwhile", id, ":\n", "", ""));
	incWhileID();
	*ss = createRecord(str2, "");
	freeRecord(*exp);
	freeRecord(*commands);
	free(str1);
	free(str2);
};


//args : tipo ID 
void argumentoTipoId(record **ss, char **s1, record **s3) {
	char *str;

	if (0 == strcmp((*s3)->code, "string"))
	{
		str = cat("char *", " ", (*s1), "", "");
	}
	else if (0 == strcmp((*s3)->code, "boolean"))
	{
		str = cat("int", " ", (*s1), "", "");
	}
	else
	{
		str = cat((*s3)->code, " ", (*s1), "", "");
	}
	*ss = createRecord(str, "");
	freeRecord(*s3);
	free(*s1);
	free(str);
};

// saida : SCANF '(' WORD ',' ID ')' PV
void scanfPalavraIdeEndereco(record **ss, char **s3, char **s5)
{
	char *str = cat("scanf(", *s3, ",", (*s5), ");\n");
	*ss = createRecord(str, "");
	free(str);
	free(*s3);
	free(*s5);
}

// | expre_arit X termo
void ex2(record **ss, record **s1, char *s2, record **s3, char *type)
{
	char *str;
	if (strcmp(s2, "^") == 0)
	{
		if (strcmp(type, "int") == 0)
		{
			str = cat("(int)pow((double)(", (*s1)->code, "), (double)(", (*s3)->code, "))");
		}
		else
		{
			str = cat("pow(", (*s1)->code, ", ", (*s3)->code, ")");
		}
	}
	else
	{
		str = cat((*s1)->code, s2, (*s3)->code, "", "");
	}

	printf("---- %s %s %s ----\n", (*s1)->code, s2, (*s3)->code);
	freeRecord(*s1);
	freeRecord(*s3);
	*ss = createRecord(str, type);
	free(str);
}

// b = expressao;
void atribuicaoVariavel(record **ss, record **s1, record **s2)
{
	char *str = cat((*s1)->code, "=", (*s2)->code, ";\n", "");
	*ss = createRecord(str, "");
	freeRecord(*s1);
	freeRecord(*s2);
	free(str);
}

// b += expressao;
void atribuicaoVariavelMaisIgual(record **ss, record **s1, record **s2)
{
	char *str = cat((*s1)->code, "+=", (*s2)->code, ";\n", "");
	*ss = createRecord(str, "");
	freeRecord(*s1);
	freeRecord(*s2);
	free(str);
}

// b -= expressao;
void atribuicaoVariavelMenosIgual(record **ss, record **s1, record **s2)
{
	char *str = cat((*s1)->code, "+=", (*s2)->code, ";\n", "");
	*ss = createRecord(str, "");
	freeRecord(*s1);
	freeRecord(*s2);
	free(str);
}

// incremento e decremento ++b ou --b ou b++ ou b--
void atribuicaoIncreDecre(record **ss, char **s1, char **s2)
{
	char *str = cat((*s1), (*s2), "", "", "");
	*ss = createRecord(str, "");
	free(*s1);
	free(*s2);
	free(str);
}
