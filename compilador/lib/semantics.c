#include "semantics.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "record.h"

// IF (' expre_logica ')' '{'
char *getIfID()
{
	char *outStr = (char *)malloc(sizeof(char) * 30);
	sprintf(outStr, "%d", ifID);

	return outStr;
};

// IF (' expre_logica ')' '{'
char *incIfID()
{
	char *outStr = (char *)malloc(sizeof(char) * 30);
	ifID++;
	sprintf(outStr, "%d", ifID);

	return outStr;
};

// WHILE (' expre_logica ')' '{'
char *getWhileID()
{
	char *outStr = (char *)malloc(sizeof(char) * 30);
	sprintf(outStr, "%d", whileID);

	return outStr;
};

// WHILE (' expre_logica ')' '{'
char *incWhileID()
{
	char *outStr = (char *)malloc(sizeof(char) * 30);
	whileID++;
	sprintf(outStr, "%d", whileID);

	return outStr;
};

// TYPE ID;
void declaracaoVariavelTipada(record **ss, record **s2, char **s4)
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
// TYPE ID = expressao;
void atribuicaoVariavelTipada(record **ss, record **id, char **type, record **expr)
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

// if_simples : IF '(' expre_logica_iterador ')' '{' bloco '}'
void ifBlock(record **ss, record **exp, record **commands, char *id)
{
	char *str1 = cat("\nif (!(", (*exp)->code, ")) goto endif", id, ";\n");
	char *str2 = cat(str1, (*commands)->code, "\n", "", "");
	*ss = createRecord(str2, "");
	freeRecord(*exp);
	freeRecord(*commands);
	free(str1);
	free(str2);
}

// if_else : IF '(' expre_logica_iterador ')' '{' bloco '}' ELSE else_aux
void ifElseBlock(record **ss, record **exp, record **ifCommands, record **elseCommands, char *id, char* type)
{	
	char *str1 = cat("\nif (!(", (*exp)->code, "))", "goto else","");
	char* str11 = cat(str1, id, "_", type,";\n");
	char *str2 = cat(str11, (*ifCommands)->code, "goto endif", id, cat(";\n}\nelse", id, "_", type, ":\n{"));
	char *str3 = cat(str2, (*elseCommands)->code, "\n", "", "");
	*ss = createRecord(str3, id);
	freeRecord(*exp);
	freeRecord(*ifCommands);
	freeRecord(*elseCommands);
	free(str1);
	free(str11);
	free(str2);
	free(str3);
}

// iteracao : WHILE '(' expre_logica_iterador ')' '{' bloco '}'
void iteradorWhile(record **ss, record **exp, record **commands, char *id)
{
	char *str1 = cat("{\n", id, ":\nif (!(", (*exp)->code, cat(")) goto end", id, ";\n", "", ""));
	char *str2 = cat(str1, (*commands)->code, "goto ", id, cat(";\nend", id, ":\n}\n", "", ""));
	*ss = createRecord(str2, "");
	freeRecord(*exp);
	freeRecord(*commands);
	free(str1);
	free(str2);
};

// args : tipo ID
void argumentoTipoId(record **ss, char **s1, record **s3)
{
	char *str;

	if (0 == strcmp((*s3)->code, "string"))
	{
		str = cat("char *", " ", (*s1), "", "");
	}
	else if (0 == strcmp((*s3)->code, "bool"))
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

// args : args ',' tipo ID 
void argumentoTipoIdRecusao(record **ss, record **args, record **tipo, char **id)
{
	char *str;

	if (0 == strcmp((*tipo)->code, "string"))
	{
		str = cat((*args)->code, ", char *", " ", (*id), "");
	}
	else if (0 == strcmp((*tipo)->code, "bool"))
	{
		str = cat((*args)->code , ", int", " ", (*id), "");
	}
	else
	{
		str = cat((*args)->code, ", ", (*tipo)->code, " ", (*id));
	}
	*ss = createRecord(str, "");
	freeRecord(*tipo);
	freeRecord(*args);
	free(*id);
	free(str);
};

//  expre_arit operador expressão aritmetica
void expressaoAritmetica(record **ss, record **s1, char *s2, record **s3, char *type)
{
	char *str;
	if (strcmp(s2, "^") == 0) {
		if (strcmp(type, "int") == 0)
		{
			str = cat("(int)pow((double)(", (*s1)->code, "), (double)(", (*s3)->code, "))");
		}
		else
		{
			str = cat("pow(", (*s1)->code, ", ", (*s3)->code, ")");
		}
	} else if (!strcmp(s2, "/")) {
		str = cat((*s1)->code, s2, "(float(", (*s3)->code, "))");
	} else if (!strcmp(s2, "%") && !strcmp(type, "float")) {
		printf("==== %s ====\n", type);
		str = cat((*s1)->code, s2, "(float(", (*s3)->code, "))");
	} else {
		str = cat((*s1)->code, s2, (*s3)->code, "", "");
	}

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
	char *str = cat((*s1)->code, "-=", (*s2)->code, ";\n", "");
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
// int[23][45] a;
void arraySemAtribuicao(record **ss, record **s2, record **s3, char *type)
{
	char *str;
	char *token1;
	char *token2;
	token1 = strtok(strdup(type), " ");
	token2 = strtok(NULL, " ");

	if (0 == strcmp(token1, "string"))
	{
		str = cat("char * ", (*s3)->code, token2, ";\n", "");
	}
	else if (0 == strcmp(token1, "bool"))
	{
		str = cat("int ", (*s3)->code, token2, ";\n", "");
	}
	else
	{
		str = cat(token1, " ", (*s3)->code, token2, ";\n");
	}
	*ss = createRecord(str, "");
	freeRecord(*s3);
	free(str);
}

// b[5][1] = expressao;
void atribuicaoArrayVariavel(record **ss, record **s1, record **s2, record **s4)
{
	char *str = cat((*s1)->code, (*s2)->code, "=", (*s4)->code, ";\n");
	*ss = createRecord(str, "");
	freeRecord(*s1);
	freeRecord(*s2);
	free(str);
}

// b[5][1] += expressao;
void atribuicaoArrayMoreEqualVariavel(record **ss, record **s1, record **s2, record **s4)
{
	char *str = cat((*s1)->code, (*s2)->code, "+=", (*s4)->code, ";\n");
	*ss = createRecord(str, "");
	freeRecord(*s1);
	freeRecord(*s2);
	free(str);
}
// b[5][1] += expressao;
void atribuicaoArrayMinusEqualVariavel(record **ss, record **s1, record **s2, record **s4)
{
	char *str = cat((*s1)->code, (*s2)->code, "-=", (*s4)->code, ";\n");
	*ss = createRecord(str, "");
	freeRecord(*s1);
	freeRecord(*s2);
	free(str);
}
// matriz[a][b]
void acessoArrayID(record **ss, char **s1, char **s2, char *type)
{
	char *str = cat(*s1, (*s2), "", "", "");
	char *token1 = strtok(strdup(type), " ");
	*ss = createRecord(str, token1);
	free(str);
	free(*s1);
	free(*s2);
}
